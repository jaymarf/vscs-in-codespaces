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
1. You may also add secrets to fill in certain values in the Codespace's appsettings.json, which is used for the devstamp when running the frontend and backend services.
    * Add a secret with name `TUNNEL_KEY` and enter the value of "tunnelRelayPrimaryAuthKey" from your local appsettings.json to automatically use it in your Codespace's appsettings.json
    * Add a secret with name `APP_SECRET` and enter the value of "appServicePrincipalClientSecret" from your local appsettings.json to automatically use it in your Codespace's appsettings.json
    * Add a secret with name `DEVELOPER_ALIAS` and enter the value of "developerAlias" from your local appsettings.json to automatically use it in your Codespace's appsettings.json
        * If you don't add a `DEVELOPER_ALIAS` secret, your git username will be used by default, however this will cause an error with your relay tunnel if your git username does not match the alias you used in your relay tunnel hybrid URL
    * Add a secret with name `CODESPACES_TOKEN` and enter an access token to automatically use it in your Codespace's testsettings.json. To get an access token in VS Code, make sure you have the old Visual Studio Codespaces extension installed and run the `Codespaces: Get Access Token` command. Make sure you run the old extension's command (`codespaces.getAccessToken`, not `github.codespaces.getAccessToken`).
    
![image](https://user-images.githubusercontent.com/33612256/105910562-fbb0a100-5fdd-11eb-9878-31d30b215689.png)

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
1. If you didn't add the necessary secrets as described in the **One-time setup** section, you can manually edit your appsettings.json in the ~/CEDev directory. Otherwise, continue with step 2.

2. Open the vscs-services.code-workspace workspace.
![image](https://user-images.githubusercontent.com/33612256/102133534-3e9a2900-3e23-11eb-9cfa-31bf294b78e8.png)

3. Open the Run tab (the play button in the left margin).

4. Select and run Launch FrontEnd + Backend Web APIs (Workspace), or you can run the (No Build) option if you've already built.
![image](https://user-images.githubusercontent.com/33612256/102133636-67bab980-3e23-11eb-846d-831e2496c0ad.png)

5. You can now use your devstamp as usual, setting the endpoint on your local .cloudenv-settings.json to your integrated dev tunnel URL, opening a new VS Code window, and creating Codespaces in your dev stamp on the old VS Codespaces extension.

## Known Issues and Planned Improvements
* The backend service crashes sometimes. This seems to be an issue with the debugger, so running the services without the debugger (Ctrl + F5) should prevent this error. Please comment on this issue if the services continue to crash while running without the debugger [#1888](https://github.com/microsoft/vssaas-planning/issues/1888)

![image](https://user-images.githubusercontent.com/33612256/102268767-b3d03180-3ee9-11eb-8d95-96f1860fcea7.png)

* As mentioned above, launching Frontend + Backend services only works in desktop Codespaces (in the VS Code extension). The bug in web Codespaces is being tracked here [#1836](https://github.com/microsoft/vssaas-planning/issues/1836)

* Though you are able to use git normally with vsclk-core in this Codespace, you will see branches from both vscs-in-codespaces (this GitHub repository) and vsclk-core. We will remove the vscs-in-codespaces branches so you'll only see the vsclk-core branches. [#1889](https://github.com/microsoft/vssaas-planning/issues/1889)
