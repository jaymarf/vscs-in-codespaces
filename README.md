# Codespaces Services in Codespaces

> _Please see the [discussion](https://github.com/microsoft/vssaas-planning/discussions/2548) and file an issue with the `dogfooding: vscs` tag in `microsoft/vssaas-planning` (tagging [Aaron Paskin](https://github.com/anpaskin) and [Josh Spicer](https://github.com/joshspicer)) with any issues._

## One-time setup
1. If you do not have write-access to the `vsls-contrib/vscs-in-codespaces` repo, request it. Forking is an option, but you'd need to update your fork when changes are made in this branch.
1. Go to https://dev.azure.com/devdiv/_usersSettings/tokens and generate a Personal Access Token that will be used to clone the vsclk-core and Cascade repos.
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
    * Add a secret with name `DEVELOPER_ALIAS` and enter the value you want to use for "developerAlias" in appsettings.json. Make sure you use the alias used in your devstamp DBs (cloud-environments-{alias}) and RelayTunnel hybrid URL (https://codespaces.servicebus.windows.net/{alias}), otherwise you will have to create a new hybrid URL and copy over plans and config to new devstamp DBs.
      * This `DEVELOPER_ALIAS` value will also be used as the "userId" in testsettings.json. "userId" needs to be your GitHub account username. If your devstamp developer alias and your GitHub username don't match, you can manually edit ~/CEDev/testsettings.json to set "userId" to your GitHub username.
    * Add a secret with name `CODESPACES_TOKEN` and enter an access token to automatically use it in your Codespace's testsettings.json. To get an access token in VS Code, run the `Codespaces: Get Access Token` command. Make sure you run the GitHub Codespaces extension's command (`github.codespaces.getAccessToken`, not `codespaces.getAccessToken`). Note for `github.codespaces.getAccessToken` to work, you will need *"isInternal": true* flag in %UserProfile%\codespaces-settings.json
    
![image](https://user-images.githubusercontent.com/33612256/105910562-fbb0a100-5fdd-11eb-9878-31d30b215689.png)

That's it, you're ready to start creating Codespaces! :rocket:

## Create your vscs-in-codespaces Codespace

1. Ensure you are on the `codespaces-service` branch of the repo page at https://github.com/vsls-contrib/vscs-in-codespaces/tree/codespaces-service. If you are using a fork, start from your fork's repo page, not the `vsls-contrib/vscs-in-codespaces` repo.

2. Click Code > Open with Codespaces

![image](https://user-images.githubusercontent.com/33612256/101836197-cb767700-3af1-11eb-9a61-ce64a2f7ea0e.png)

3. The codespace will load and automatically clone the vsclk-core and Cascade ADO repos. Wait for the configuration to complete.

> You can check provisioning status with the `Codespaces: View Creation Log` vscode command. You will see the text in the following image when complete.  It takes about a minute to clone and restore both repos!
> 
> ![3](images/3.png)

4. **AFTER** the initialization script completes, open `codespaces-service.code-workspace` from the file explorer and select `OPEN WORKSPACE` (or click the workspace pop-up that will automatically appear).

### Organization

This will give you a clean workspace organized like:

```
.
├── Cascade
    ├── bin
    ├── ...
└── vsclk-core
    ├── bin
    ├── ...
```

This will recursively pull in the workspace and `.vscode` config for each of the repos. This will also populate the "Run" with the relevant launch commands.

![image](https://user-images.githubusercontent.com/33612256/106797794-f07af800-6611-11eb-9634-c960e3706636.png)

5. In the C# extension settings, ensure that Omnisharp: Project Load Timeout is > 200.

6. Run the VSCode command Omnisharp: Select Project to set VSCode's focus to the project you're working on. Selecting a project will help omnisharp enable intellisense and other nice editor features for the code you're working on.

For agent development you may want to select the VSOnline.sln.

For services development you may want to select the Codespaces.sln.

Wait until all projects are loaded in the Omnisharp logs (If there is an error, you may need to run `dotnet restore` in the VS Code command line). You can set the `Omnisharp: Default Launch Solution` in the C# extension settings as well.

![image](https://user-images.githubusercontent.com/33612256/101835693-01672b80-3af1-11eb-97d7-a5bda056f9d3.png)

7. Begin coding with Intellisense! Via the source control panel you can see changes you've made in Cascade, vsclk-core, or this bootstrap repo. Cd into the vsclk-core or VSOnline folder and fetch and checkout your branch, or create a new branch. Make commits how you normally would for each individual repo.

![source-control](images/source-control.png)

The `.codespaces` directory cloned from vscs-in-codespaces is not deleted, and can still be accessed via your terminal at `~/workspace/vscs-in-codespaces/.codespaces`.  The `.codespaces` directory is added to your `$PATH`, letting you run any of our pre-build scripts in that directory from your terminal.

## Running Your Devstamp in vscs-in-codespaces

The end-to-end developer stamp allows you to exercise the client(s), frontend/backend webservices, and the vso cli. This is a useful tool for anyone who is developing features which span the above codebases. It provides isolated databases, azure resource groups, blob storage etc. This is a hybrid development environment. Real resources are created in Azure, despite running the web services locally.

These steps outline how to set up and run your devstamp from your vscs-in-codespaces Codespace. If you've used devstamp before, you may have already completed some of these steps. You may skip whichever steps you've already completed.

1. Recommended: Connect to your vscs-in-codespaces Codespace on web by going to [github.com/codespaces](github.com/codespaces) and selecting your Codespace.
   * You can run your devstamp from desktop VS Code, but you'll need to use a separate VS Code instance with different settings to create Codespaces that point to your devstamp (and thus have your changes). This might accidentally mess up the settings for your initial VS Code instance where you're running your devstamp.

2. Set up your RelayTunnel hybrid URL using the instructions [here](https://github.com/microsoft/vssaas-planning/wiki/Integrated-Devstamp-Tunnel).

3. If you didn't add the necessary secrets as described in the [**One-time setup**](https://github.com/vsls-contrib/vscs-in-codespaces/blob/codespaces-service/README.md#one-time-setup) section, open ~/CEDev/appsettings.json. The terminal `code` command doesn't work in Codespaces ([issue](https://github.com/microsoft/vssaas-planning/issues/1920)), so the easiest way to open this file is to hit ctrl + p, type ~/CEDev/appsettings.json and select the file in the dropdown. Set the following values if they are not set:
   * `"developerAlias": "{alias}"`, where `alias` is the alias you used in your RelayTunnel hybrid URL (`https://codespaces.servicebus.windows.net/{alias}`)
   * `"appServicePrincipalClientSecret": "******"`. where `******` is the value of the `app-sp-password` secret in the [`vsclk-online-dev-kv`](https://ms.portal.azure.com/#@microsoft.onmicrosoft.com/resource/subscriptions/86642df6-843e-4610-a956-fdd497102261/resourceGroups/vsclk-online-dev/providers/Microsoft.KeyVault/vaults/vsclk-online-dev-kv/secrets) KeyVault.

4. If you are testing a Cascade repo change (in the VSOnline folder of your Codespace), run `deploy-custom-agent.sh` in the VS Code terminal to build and upload an image with your changes for the devstamp to use. You can read more about what this script does in the [**Deploying a Custom Agent**](https://github.com/vsls-contrib/vscs-in-codespaces/blob/codespaces-service/README.md#deploying-a-custom-agent) section below.

5. Open the Run tab (the play button in the left margin) and select FrontEnd+Backend API Launch in the dropdown (or the (No Build) option if you've already built the frontend and backend services, either manually or with a previous devstamp run).

For best results, run the services without debugging by hitting ctrl + F5. If you need debugging you may try to run the services by clicking the green play button next to the task name in the Run tab, however you will likely get exceptions. See the [dogfooding/devstamp discussion](https://github.com/microsoft/vssaas-planning/discussions/2548), where we are tracking debugger in Codespaces issues.
   * If you are running the services with the prelaunch build (the task without (No Build)), the task may take a minute or two to launch. Once it starts, you will see the prelaunch build task begin with restores in your terminal

![image](https://user-images.githubusercontent.com/33612256/107100380-05e65280-67c9-11eb-872e-5253828d3b49.png).

6. You should then see the DEBUG CONSOLE opened, with FrontEndWebApi Launch and BackEndWebApi Launch in the dropdown in the top right of the DEBUG CONSOLE. Select TERMINAL next to DEBUG CONSOLE to see logs from your running services, the names of which are listed in the same top right dropdown.

7. You can open the running Diagnostics Dashboard by opening the Run tab in the left margin, hovering over the forwarded port 59330 and clicking the globe icon.  TODO: Add link to Diagnostics Dashboard instructions.

![image](https://user-images.githubusercontent.com/33612256/107100656-e4399b00-67c9-11eb-94f7-f4b8ef08acd9.png)

8. You'll need your GitHub Codespaces plan in the global frontend database that your devstamp creates for you. Follow the instructions in the devstamp wiki's [**Copying Your GitHub Codespaces PLan**](https://github.com/microsoft/vssaas-planning/blob/master/docs/Devstamp/e2e-devstamp.md#copying-your-github-codespaces-plan) to find and copy your plan(s) into your frontend DB.
   * Currently each combination of billable repo owner + VSCS target (local/dev, ppe, prod, etc.) + region has a unique plan, so depending on the repos from which you're trying to create devstamp Codespaces, you may need to copy over additional plans.

9. Once your devstamp is launched, see the status of the provisioning resources in [your backend db](https://ms.portal.azure.com/#@microsoft.onmicrosoft.com/resource/subscriptions/86642df6-843e-4610-a956-fdd497102261/resourceGroups/vsclk-online-dev-ci-usw2/providers/Microsoft.DocumentDb/databaseAccounts/vsclk-online-dev-ci-usw2-db/dataExplorer). You should mainly look for your compute and storage resources with the filters `WHERE c.type = "ComputeVM"` and `WHERE c.type = "StorageFileShare"`. Each of these resources has an `isReady` property that will be true when the resource is provisioned. You need one compute and one storage resource to create an environment.

You can also see the status of your resources by adding the `Pool Size` card to your Diagnostics Dashboard with the plus sign in the upper left and by adding a Tunnel Logs card using the instructions in the [**Diagnostic Dashboard Card**](https://github.com/microsoft/vssaas-planning/blob/master/docs/Devstamp/integrated-devstamp-tunnel.md#diagnostic-dashboard-card-optional) at the bottom of the Integrated Devstamp Tunnel wiki. When you have provisioned VMs your Tunnel Logs card should look like this:

![image](https://user-images.githubusercontent.com/33612256/106959574-b08a4280-66ef-11eb-95a7-4d99a732b505.png).

10. On your local machine (NOT in your Codespace), create a file called `codespaces-settings.json` in `C:\Users\{your Windows username}` if on Windows or `~` if on Mac. Add the following to your `codespaces-settings.json` file:

```
{
  "isInternal": true,
  "vscsTarget": "local",
  "vscsTargetUrl": "https://codespaces.servicebus.windows.net/<your alias>"
}
```

This will tell your local VS Code instance to point to your devstamp so you can create Codespaces with your changes. See the [**Configure your VSCode endpoint**](https://github.com/microsoft/vssaas-planning/blob/master/docs/Devstamp/e2e-devstamp.md#configure-your-vscode-endpoint) section for more info on the `codespaces-settings.json`, including how to configure it tell VS Code to point to dev or ppe.

11. Open VS Code (Insiders recommended for the latest extension updates) and create a Codespace from the repo with which you want to test your changes using the Standard SKU. This Codespace will have your changes.

## Tips & Tricks - Diagnosing Devstamp Issues

> The first two devstamp Codespaces created in a devstamp session seem to fail, possibly due to some bug with the two hot pooled Codesapces that a devstamp starts with. This issue is being tracked here https://github.com/microsoft/vssaas-planning/issues/2322. Try creating three devstamp Codespaces, and if the third creation fails, see the following tips.

1. **<span style="text-decoration:underline">Azure Exception</span>**
    If the BackendApi outputs an error that is related to Azure, you'll see a *correlation/tracking id.* We can use that to get some further information from ARM. The error line will also contain `AzureSubscription` which we'll need as well.

    In the Azure CLI, you run:
    
    `az monitor activity-log list --correlation-id 14712f24-09d9-4282-98c3-4fd163f9fe75 --subscription e4c062b5-2f72-415d-8a4a-ad37c8caf10a`

    Which should give you a detailed log about what went wrong.
    
2. **<span style="text-decoration:underline">502 error (Unicorn on github.com):</span>**
  
  There are a few reasons why you may be getting this.
  
  a. Make sure you have the right plan copied to your dev stamp db. If you are seeing "Forbidden" error message or some other create error from Diagnostic page this can be the reason, wrong plan. Follow [these steps](https://github.com/microsoft/vssaas-planning/blob/master/docs/Devstamp/e2e-devstamp.md#copying-your-github-codespaces-plan) to find and copy the plan you need.
  
:warning: Currently each combination of billable repo owner + VSCS target (local/dev, ppe, prod, etc.) + region has a unique plan, so depending on the repo from which you're trying to create a devstamp Codespace, you may need to copy over an additional plan.
  
  b. Github has 10 sec time-out, so if you have debugger attached and it hits a breakpoint for more than that it can cause a timeout and you would see that as a 502, so make sure you run your services without debugger attached to it.
  
  c. Quota: There may be too many Codespace records in your regional frontend DB. The nightly cleandevstamp process clears out these records, but if you want to clean the records manually:
    
   1. Open Powershell as administrator
   1. Run `Install-Module cosmos-db`
   1. Run `Import Module {PATH}/{TO}/vsclk-core/tools/Powershell/codespaces-db.psm1`
   1. Run `Remove-CodespaceDBRecordsWhere -database Environments -query 'select * from c' -controlPlane Local`

You can confirm the commands worked by checking that your [regional db's](https://ms.portal.azure.com/#@microsoft.onmicrosoft.com/resource/subscriptions/86642df6-843e-4610-a956-fdd497102261/resourceGroups/vsclk-online-dev-ci-usw2/providers/Microsoft.DocumentDB/databaseAccounts/vsclk-online-dev-ci-usw2-regional-db/overview) `cloud_environments` collection is empty.

3. **VM Creation Failures**: If you're not receiving logs in your Tunnel Logs Diagnostics dashboard card, your VM creations might be failing. Stop your devstamp, [upload a custom CLI](https://github.com/microsoft/vssaas-planning/blob/master/docs/Devstamp/e2e-devstamp.md#option-2-custom-cli) and restart your devstamp. You can check [your backend db](https://ms.portal.azure.com/#@microsoft.onmicrosoft.com/resource/subscriptions/86642df6-843e-4610-a956-fdd497102261/resourceGroups/vsclk-online-dev-ci-usw2/providers/Microsoft.DocumentDb/databaseAccounts/vsclk-online-dev-ci-usw2-db/dataExplorer) and filter with `where c.type = "ComputeVM"` to see if your VM creations are succeeding.

4. **Unhealthy Heartbeats**: If the VM heartbeat logs in your Diagnostics Dashboard don't look healthy (like the image below),

![image](https://user-images.githubusercontent.com/33612256/106959574-b08a4280-66ef-11eb-95a7-4d99a732b505.png)

you can delete all the VMs in your backend DB by doing:

   1. Open Powershell as administrator
   1. Run `Install-Module cosmos-db`
   1. Run `Import Module {PATH}/{TO}/vsclk-core/tools/Powershell/codespaces-db.psm1`
   1. Run `Remove-CodespaceDBRecordsWhere -database Resources -query 'select * from c where c.type = "ComputeVM"' -controlPlane Local`
   
See the Diagnostic Dashboard Card instructions on the [Integrated DevStamp Tunnel](https://github.com/microsoft/vssaas-planning/wiki/Integrated-Devstamp-Tunnel#diagnostic-dashboard-card-optional) page to learn how to add and configure a card that will print heartbeat logs from your RelayTunnel service.

## Deploying a Custom Agent

You can run the `deploy-custom-agent.sh` script (on your `$PATH`, source [here](https://github.com/vsls-contrib/vscs-in-codespaces/edit/codespaces-service/.codespaces/deploy-custom-agent.sh)) which will:

1. Build Cascade
2. Build Vsclk-Core
3. Generate the agent artifacts with Cascade's `DevTool.dll`
4. Upload to Azure to be used in your personal devstamp with vsclk-core's `VsoUtil.dll`.

> You may specify the **`--no-build`** flag to skip steps 1 and 2, although you'll need to have built at some point to have the `DevTool` and `VsoUtil` dlls present.


The output will look similar to this:

![5](images/5.png)
![7](images/7.png)

Your appsettings.json file in `~/CEDEev` will be updated with the correct values and `"autoUploadLocalVMAgents"` set to false.

## Running E2E Raw API Tests

See the **Codespaces in Codespaces** section of the [Automated Test Runners wiki](https://github.com/microsoft/vssaas-planning/blob/master/docs/Design/automated-test-runners.md#codespaces-in-codespaces) for instructions on running the E2E tests in vscs-in-codespaces.
