# VSCS in Codespaces

Welcome to VSCS in Codespaces! Here you can open any ADO repository in a GitHub Codespace. This repository has several branches configured for developing with specific ADO repositories in GitHub Codespaces. If any of these projects are what you want to open in a Codespace, follow the README instructions in the relevant branch linked below. If you want to open a different ADO repository not listed here, continue with the instructions below.

[<img title="Run in Codespace in one click" src="https://cdn.jsdelivr.net/gh/bookish-potato/codespaces-in-codespaces@f097ccddfc401ab6b09d233dc47c3efa3f9513f6/images/badge.svg">](https://github.com/features/codespaces)

- Portal: https://github.com/vsls-contrib/vscs-in-codespaces/tree/portal
- Codespaces extension: https://github.com/vsls-contrib/vscs-in-codespaces/tree/codespaces-extension
- LiveShare extension: https://github.com/vsls-contrib/vscs-in-codespaces/tree/liveshare-extension
- Codespaces service + VMAgent (vsclk-core + cascade): https://github.com/vsls-contrib/vscs-in-codespaces/tree/codespaces-service

## Open Any ADO Repo In Codespaces

### One-time setup
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
    
### Create a Codespace
1. Click Code > Open with Codespaces
1. In the VS Code terminal, run ./init and follow the instructions, pasting in the url to your ADO repo.

## Issues?

IF you encounter any problems with VSCS in Codespaces, please file an issue in `microsoft/vssaas-planning` with the appropriate `dogfooding` tag.
