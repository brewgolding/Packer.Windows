using System.Reflection.Metadata.Ecma335;
using System.IO;
using System.IO;

using System.IO;

using System;
using YamlDotNet.Serialization;
using Newtonsoft.Json;

// addins
#addin nuget:?package=Cake.Powershell&version=1.0.1
#addin nuget:?package=YamlDotNet&version=11.2.1
#addin nuget:?package=Newtonsoft.Json&version=13.0.1

// tools
#tool nuget:?package=Cake.CoreCLR&version=1.3.0

//////////////////////////////////////////////////////////////////////
// ARGUMENTS
//////////////////////////////////////////////////////////////////////

var target = Argument("target", "BuildBaseInstall");
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
      var yamlString = System.IO.File.ReadAllText(variablesFile);
      var yamlStringReader = new StringReader(yamlString);
      var deserializer = new Deserializer();
      dynamic yamlObject = deserializer.Deserialize(yamlStringReader);
      dynamic expando = new System.Dynamic.ExpandoObject();
      expando.variables = yamlObject;
      yamlObject = expando;
      var jsonSerializer = new JsonSerializer();
      var stringWriter = new StringWriter();
      jsonSerializer.Serialize(stringWriter, yamlObject);
      //Console.SetOut(stringWriter);
      System.IO.File.WriteAllText("variables.pkr.json", stringWriter.ToString());
    }

    );
Task("BuildBaseInstall")
    .IsDependentOn("Configure")
    .Does(() =>
{
    Console.WriteLine("Building");
    var packerPath = new FilePath("packer");
    StartProcess(packerPath, "build -only=Base-Install.* .");
});
/*
Task("Test")
    .IsDependentOn("Build")
    .Does(() =>
{
    DotNetCoreTest("./src/Example.sln", new DotNetCoreTestSettings
    {
        Configuration = configuration,
        NoBuild = true,
    });
});
*/
//////////////////////////////////////////////////////////////////////
// EXECUTION
//////////////////////////////////////////////////////////////////////

RunTarget(target);
