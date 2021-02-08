# Codespaces Portal in GitHub Codespaces

[<img title="Run in Codespace in one click" src="https://cdn.jsdelivr.net/gh/bookish-potato/codespaces-in-codespaces@f097ccddfc401ab6b09d233dc47c3efa3f9513f6/images/badge.svg">](https://github.com/features/codespaces)

> :warning: You cannot run portal from Codespaces on the web, your `yarn start` needs to be from VSCode Desktop

**From :warning: Desktop :warning: VSCode:**

1. Create a Codespace using this `portal` branch.

![image](https://user-images.githubusercontent.com/1478800/100968319-f6efd500-34e5-11eb-96ab-737db212b7d5.png)

![image](https://user-images.githubusercontent.com/1478800/100968383-1850c100-34e6-11eb-8bc2-098b18a57108.png)

2. Once connected, run `./init` command to start the bootstrap process, follow instructions.

![image](https://user-images.githubusercontent.com/1478800/100968557-649c0100-34e6-11eb-9d58-e72370f70fd1.png)

![image](https://user-images.githubusercontent.com/1478800/100968588-741b4a00-34e6-11eb-8ead-dd2fcbc65f67.png)

3. Once complete, run `code -r .` in the terminal to open the current folder.

![image](https://user-images.githubusercontent.com/1478800/100970585-14bf3900-34ea-11eb-99e5-553cdc9eb477.png)

4. Run `yarn start` to start the portal, it will auto-forward the port `5000`.

![image](https://user-images.githubusercontent.com/1478800/100968769-d2482d00-34e6-11eb-9c4e-80cb1322b81a.png)

5. Download the `nginx` folder from this repo, open it in vscode and run `./start.sh` script (`./start.ps1` for Windows).

In case you get an error for Execution policy, run `Set-ExecutionPolicy -ExecutionPolicy Unrestricted` from admin powershell window. 
![image](https://user-images.githubusercontent.com/1478800/100968925-1dfad680-34e7-11eb-9f9c-62801235ce76.png)

6. Go to `https://github.com/codespaces` and create a repo with `local` VSCS target.

![image](https://user-images.githubusercontent.com/1478800/100968999-3cf96880-34e7-11eb-92bb-0d8b30b1db12.png)

7. Done.

![image](https://user-images.githubusercontent.com/1478800/100969828-9746f900-34e8-11eb-840a-3ff9f44506bf.png)

**Misc**

Query params for the portal:
 - `?vscodeCommitId={SHA}` - to define the commit from the codespace URL, e.g. https://codespace-legomushroom-simple-server-7h6j.github.localhost/?vscodeCommitId=92192baf760315ac47fb2caaf3ce6d0778962352
 - `?vscodeChannel=stable` - to define the vscode quality (either stable or insider), can be combined with the above, e.g. https://codespace-legomushroom-simple-server-7h6j.github.localhost/?vscodeCommitId=93c2f0fbf16c5a4b10e4d5f89737d9c2c25488a3&channel=stable

**Issues/Feedback**

- Feedback appreciated, create issues on this repo if anything 🤗
