# vsclk-core in Codespaces
## One-time setup
1. If you do not have write-access to the `vsls-contrib/vscs-in-codespaces` repo, go ahead and fork it now
1. Go to https://dev.azure.com/devdiv/_usersSettings/tokens and generate a Personal Access Token that will be used to clone the repo where the Codespaces extension lives
1. Click `New Token` and select the following settings:
    * `Organization: All accessible organizations`
    * `Scope: Code Read & Write`
    * `Scope: Packaging Read`
1. Copy the token
1. Go to https://github.com/settings/codespaces and click `New secret`
    * Name: `ADO_PAT` _:warning: Warning: the name must be called `ADO_PAT` for the init scripts to work!_
    * Value: Paste in the generated PAT
    * Repository access: `vsls-contrib/vscs-in-codespaces` (or if you are using a fork, select your fork)
    
That's it, you're ready to start creating Codespaces! :rocket:

## Create a Codespace
1. Ensure you are on the `codespaces-service` branch of the repo page at https://github.com/vsls-contrib/vscs-in-codespaces/tree/codespaces-service. If you are using a fork, start from your fork's repo page, not the `vsls-contrib/vscs-in-codespaces` repo.
1. Click Code > Open with Codespaces
![image](https://user-images.githubusercontent.com/33612256/101836197-cb767700-3af1-11eb-9a61-ce64a2f7ea0e.png)
1. The codespace will load and automatically clone the vsclk-core ADO repo. Wait for the configuration to complete. You can track this in the `Creation Log`, such as by running the `Codespaces: View Creation Log` and viewing `Configure Codespace`.
![image](https://user-images.githubusercontent.com/746020/101095940-99a26500-3573-11eb-8bf1-1ae14d2d8dd1.png)
1. In the C# extension settings, ensure that Omnisharp: Project Load Timeout is > 200.
1. Run the command `Omnisharp: Select Project` and select Codespaces.sln. Wait until all projects are loaded in the Omnisharp logs (If there is an error, you may need to run `dotnet restore` in the VS Code command line). You can set the Omnisharp: Default Launch Solution in the C# extension settings as well.
![image](https://user-images.githubusercontent.com/33612256/101835693-01672b80-3af1-11eb-97d7-a5bda056f9d3.png)
1. Begin coding with Intellisense!

## Running the Frontend and Backend Services
:warning: Warning: Launching Frontend + Backend services only works in desktop Codespaces (in the VS Code extension). The bug in web Codespaces is being tracked here [#1836](https://github.com/microsoft/vssaas-planning/issues/1836)

:warning: Warning: Ngrok is not currently configured in this Codespace, so you should use your devstamp tunnel Azure Relay url instead, which you can set up using the instructions [here](https://github.com/microsoft/vssaas-planning/wiki/Integrated-Devstamp-Tunnel)
1. A CEDev directory will have been generated automatically for your appsettings.json. Run the following commands in the VS Code terminal
```
cd ~/CEDev
code appsettings.json
```
and paste in your appsettings.json. Make sure you've added the `"developerAlias": "<alias>"` property to appsettings.json with your alias. Without this, running the services in a Codespace will try to create resources with the `codespace` username, causing an error.

![image](https://user-images.githubusercontent.com/33612256/102140759-bf5e2280-3e2d-11eb-8290-b8ee45e9844f.png)

2. Open the vscs-services.code-workspace workspace.
![image](https://user-images.githubusercontent.com/33612256/102133534-3e9a2900-3e23-11eb-9cfa-31bf294b78e8.png)

3. Open the Run tab.

4. Select and run Launch FrontEnd + Backend Web APIs (Workspace), or you can run the (No Build) option if you've already built.
![image](https://user-images.githubusercontent.com/33612256/102133636-67bab980-3e23-11eb-846d-831e2496c0ad.png)

5. You can now use your devstamp as usual, setting the endpoint on your local .cloudenv-settings.json to your integrated dev tunnel URL, opening a new VS Code window, and creating Codespaces in your dev stamp on the old VS Codespaces extension.

## Known Issues and Planned Improvements
* The backend service may crash the first time running it in a new Codespace. Suspending and resuming the Codespace usually resolves this, but we will continue to track the issue here [#1888](https://github.com/microsoft/vssaas-planning/issues/1888)

![image](https://user-images.githubusercontent.com/33612256/102268767-b3d03180-3ee9-11eb-8d95-96f1860fcea7.png)

* As mentioned above, launching Frontend + Backend services only works in desktop Codespaces (in the VS Code extension). The bug in web Codespaces is being tracked here [#1836](https://github.com/microsoft/vssaas-planning/issues/1836)

* Automatically create an appsettings.json with default values, allowing users to pass in values like developerAlias as Codespace secrets [#1887](https://github.com/microsoft/vssaas-planning/issues/1887)

* Though you are able to use git normally with vsclk-core in this Codespace, you will see branches from both vscs-in-codespaces (this GitHub repository) and vsclk-core. We will remove the vscs-in-codespaces branches so you'll only see the vsclk-core branches. [#1889](https://github.com/microsoft/vssaas-planning/issues/1889)
