import { colors } from "https://deno.land/x/cliffy@v0.25.6/ansi/colors.ts";
import { Table } from "https://deno.land/x/cliffy@v0.25.6/table/mod.ts";
import { exec, OutputMode } from "https://deno.land/x/exec/mod.ts";

import {
  Checkbox,
  Confirm,
  Input,
} from "https://deno.land/x/cliffy@v0.25.7/prompt/mod.ts";
import { resolvePath } from "./utils/filePaths.ts";

// Define theme colors.
const error = colors.bold.red;
const warn = colors.bold.yellow;
const info = colors.bold.blue;
const success = colors.bold.green;

let email: string, name: string;

// await initialize();
// await promptSudo();

// await installBrew();
// await installBrewApps("./requirements/brew.txt");
// await installBrewApps("./requirements/cask.txt");
await installFonts();

async function checkStatus(code: number, type: string) {
  if (code !== 0) {
    console.log(error(`An error occurred during ${type}.`));
    if (await confirmStep("next step?")) {
      return;
    }
    Deno.exit(0);
  }
  console.log(success(`Completed: ${type}.`));
}

async function confirmStep(desc: string) {
  return await Confirm.prompt(`Continue to ${desc}`);
}

async function installFonts() {
  // =========== Remote fonts ===========
  await exec("brew tap homebrew/cask-fonts");
  const p = Deno.run({
    cmd: "brew install --cask font-fira-mono-nerd-font font-fira-code-nerd-font".split(
      " "
    ),
  });
  const { code: remoteStatusCode } = await p.status();
  await checkStatus(remoteStatusCode, "Remote font installation");

  // =========== Local fonts ===========
  console.log(info("Installing local fonts"));

  const localCopy = Deno.run({
    cmd: "/bin/bash -c ./fonts/install.sh".split(" "),
  });
  const { code: localStatusCode } = await localCopy.status();
  await checkStatus(localStatusCode, "Local font installation");
}

async function installBrew() {
  const previousInstallation = await exec("which brew", {
    output: OutputMode.Capture,
  });

  if (previousInstallation.status.success) {
    console.log(success("Brew already installed"));
    return;
  } else {
    console.log(warn("Installing brew"));

    const scriptSrc = await exec(
      "curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh",
      { output: OutputMode.Capture }
    );
    const p = Deno.run({ cmd: ["/bin/bash", "-c", scriptSrc.output] });

    const { code } = await p.status();

    checkStatus(code, "Brew installation");
  }
}

async function installBrewApps(sourcePath: string) {
  const file = await Deno.readTextFile(resolvePath(sourcePath));
  const input = file.trim().split("\n");

  const apps = await Checkbox.prompt({
    message: "What programs do you wish to install with Brew?",
    options: input,
  });
  if (!(await Confirm.prompt(`Will install ${apps.length} applications`))) {
    console.log(info("Will not install any Brew dependencies"));
    return;
  }

  const p = Deno.run({ cmd: ["brew", "install", ...apps] });

  const { code } = await p.status();
  checkStatus(
    code,
    `Brew app installation from ${sourcePath.split("/").at(-1)}`
  );
}

async function promptSudo() {
  console.log(info("We might need your sudo password to install/configure"));
  await exec(`sudo -v`); // validates the sudo password and caches it for 5 minutes
  await exec(`sudo -n`); // non-interactive – avoids propmpting for sudo again
  console.log(
    info("ℹ️  Sudo password set. You will not be asked again for 5 minutes.")
  );
}

async function initialize() {
  email = await Input.prompt({
    message: "Enter your email",
    default: email ?? "rikardeide@gmail.com",
  });

  name = await Input.prompt({
    message: "Enter your name",
    default: name ?? "Rikard Eide",
  });

  console.log({ email, name });
  if (!(await Confirm.prompt("Is everything correct?"))) {
    await initialize();
  }

  console.log(info("\nAll set! Here's what will happen next"));

  const tableOfContents: Table<[string, number]> = Table.from([
    ["Set MacOS defaults", 10],
    ["Install brew", 60 * 2],
    ["Install command line software (Brew)", 60 * 5],
    ["Install useful software (Brew cask)", 60 * 4],
    ["Configure Fish shell and Starship prompt", 60 * 2],
    ["Install Fish plugins (Fisher)", 60],
    ["Install fonts", 10],
    ["Symlink other configuration files", 10],
  ]);

  const sum = tableOfContents
    .map((el) => el[1])
    .reduce((sum, next) => sum + next, 0);
  tableOfContents.push(["Total ETA", sum]);
  const formatted = tableOfContents
    .map((el, index) => [
      index === tableOfContents.length - 1 ? "\ue0b0" : index + 1,
      el[0],
      humanize(el[1]),
    ])
    .toString();

  console.log(formatted);

  if (!(await Confirm.prompt("Ready to roll?"))) {
    console.log(info("Exiting..."));

    Deno.exit(0);
  }
  console.log(error("Not implemented yet!"));
}

function humanize(num: number) {
  const inMinutes = num / 60;
  if (inMinutes < 1) {
    return `~${num} seconds`;
  }
  return `~${inMinutes} minute${inMinutes > 1 ? "s" : ""}`;
}
