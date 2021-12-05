using System.IO;
using YamlDotNet.Serialization;
using YamlDotNet.Serialization.NamingConventions;
using System.Dynamic;
using System;
using Newtonsoft.Json;

// addins
#addin nuget:?package=YamlDotNet
#addin nuget:?package=Newtonsoft.Json

// tools
#tool paket:?package=Cake.CoreCLR

//////////////////////////////////////////////////////////////////////
// ARGUMENTS
//////////////////////////////////////////////////////////////////////
var target = Argument("target", "Build");
var configuration = Argument("configuration", "NonProduction");
var variablesFile = Argument("variablesFile","variables.yaml");

//////////////////////////////////////////////////////////////////////
// PREPARATION
//////////////////////////////////////////////////////////////////////

// Define directories.
var buildDir = Directory("./build") + Directory(configuration);

//////////////////////////////////////////////////////////////////////
// TASKS
//////////////////////////////////////////////////////////////////////

Task("Clean")
    .WithCriteria(c => HasArgument("rebuild"))
    .Does(() =>
{
    CleanDirectory(buildDir);
});

Task("Configure")
    .IsDependentOn("Clean")
    .Does(() =>
    {
      var deserializer = new YamlDotNet.Serialization.DeserializerBuilder()
        .WithNamingConvention(CamelCaseNamingConvention.Instance)
        .Build();
      dynamic yamlObject = new {
        variables = deserializer.Deserialize<ExpandoObject>(System.IO.File.ReadAllText(variablesFile))
      };
      //Replaces the yamlconfig build.directory with the variable buildDir
      yamlObject.variables.build["directory"] = buildDir.ToString();
      var jsonSerializer = new JsonSerializer();
      var stringWriter = new StringWriter();
      jsonSerializer.Serialize(stringWriter, yamlObject);
      System.IO.File.WriteAllText("variables.pkr.json", stringWriter.ToString());
    }

    );

Task("Build Base Install")
  .IsDependentOn("Configure")
  .Does(() =>
  {
    var packerPath = new FilePath("packer");
    StartProcess(packerPath, "build -only=Base-Install.* .");
    });
Task("Build DSCProvision")
  .IsDependentOn("Build Base Install")
  .Does(() =>
  {
    var packerPath = new FilePath("packer");
    StartProcess(packerPath, "build -only=DSCProvision.* .");
    });
  
Task("Build")
    .IsDependentOn("Build DSCProvision")
    .Does(() =>
{
  Console.WriteLine("Build Complete");
});


//////////////////////////////////////////////////////////////////////
// EXECUTION
//////////////////////////////////////////////////////////////////////

RunTarget(target);
