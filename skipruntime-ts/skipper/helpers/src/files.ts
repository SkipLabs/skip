import {
  cp,
  stat,
  access,
  copyFile,
  writeFile,
  readFile,
  mkdir,
  mkdtemp,
  rename,
  rm,
  appendFile,
  readdir,
  unlink,
} from "fs/promises";
import { constants, Dirent } from "fs";
import path from "path";

export { writeFile, mkdir, mkdtemp, rm, appendFile, unlink };

export async function isDirectory(path: string) {
  try {
    return (await stat(path)).isDirectory();
  } catch {
    return false;
  }
}

export async function fileExists(path: string): Promise<boolean> {
  try {
    await access(path, constants.F_OK);
    return true;
  } catch {
    return false;
  }
}

export async function copyDir(src: string, dest: string) {
  await cp(src, dest, {
    recursive: true,
    force: true,
  });
}

export async function moveFile(src: string, dest: string): Promise<void> {
  await mkdir(path.dirname(dest), { recursive: true });
  try {
    await rename(src, dest);
  } catch (err) {
    if ((err as NodeJS.ErrnoException).code === "EXDEV") {
      await copyFile(src, dest);
      await unlink(src);
    } else {
      throw err;
    }
  }
}

export async function getFileContent(
  path: string,
  encoding: "utf-8" | null = null,
): Promise<string | undefined> {
  try {
    const buffer = await readFile(path, {
      encoding,
    });
    return buffer.toString();
  } catch {
    return undefined;
  }
}

export async function listFiles(dir: string, recurse: boolean = true) {
  const entries = await readdir(dir, { withFileTypes: true });

  const files: (string | string[])[] = await Promise.all(
    entries.map(async (entry: Dirent) => {
      const fullPath = path.join(dir, entry.name);
      if (entry.isDirectory() && recurse) {
        return (await listFiles(fullPath, recurse)).map((p) =>
          path.join(entry.name, p),
        ); // recurse
      } else {
        return entry.name;
      }
    }),
  );

  return files.flat();
}

export function splitPath(p: string) {
  return p.split(path.sep);
}
