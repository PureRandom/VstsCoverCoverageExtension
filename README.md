# Resharper DotCover Analysier

This is a VSTS task that creates the Resharper DotCover Analyse command line and executes it.

### Usage
The aim of this task is not to reinvent the wheel, but to facilitate users with DotCover in VSTS.
Therefore please refer to [JetBrains](https://www.jetbrains.com/help/dotcover/Running_Coverage_Analysis_from_the_Command_LIne.html) for how to use the command line.

#### Recursive Project Finding
As well as using all the commands the command line offers, it can also be use for multiple projects. Instead of in the Target Arguments passing each project seperatley and manually, you can pass wildcards in the Project Pattern.

If you pass anything in the Project Pattern parameter it will detect you want to use this feature. It then uses the Target Working Directory as the base to recursivley search.

For Example:
  Project Pattern = "*Test.dll"
  Target Working Directory = "/Source"

This will search for all DLL that end with 'Test' in the 'Source' directory and then prepend it to any other arguments in the Target Arguments.

### Further Information
- Resharper DotCover Analyse - [JetBrains](https://www.jetbrains.com/help/dotcover/Running_Coverage_Analysis_from_the_Command_LIne.html)
- Christopher Pateman - [PR Code](https://prcode.blog)

### Support
This currently uses the JetBrains version - JetBrains.dotCover.CommandLineTools.2017.3.2

It runs the command through the Windows Command Line, so it also must be installed and set in the environment settings.

All bugs found, please raise a bug on the Git Hub Issues.

### Legal
This is not an offical task by JetBrains or sponsored by JetBrains. Resharper is a registered trademark of JetBrains and the extension is produced independently of JetBrains.
