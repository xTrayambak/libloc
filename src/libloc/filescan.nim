import std/[os, strutils, posix_utils]

proc isAppendable*(
  file: string, 
  excludedExts, 
  excludedDirs: seq[string],
  excludeBins: bool
): bool =
  for eDir in excludedDirs:
    if file.startsWith(eDir):
      return false

  for eExt in excludedExts:
    if file.endsWith(eExt):
      return false

  if excludeBins:
    # TODO(xTrayambak): replace this number with S_IXUSER but it seems I can't import it.
    if stat(file).st_mode.int == 33261:
      return false

    echo $(stat(file).st_mode)

  return true

proc getAllFiles*(
  path: string, 
  excludedExtensions,
  excludedDirectories: seq[string],
  excludeBinaries: bool = true
): seq[string] =
  var files: seq[string] = @[]
  for file in walkDirRec(path):
    if isAppendable(file, excludedExtensions, excludedDirectories, excludeBinaries):
      files.add(file)

  files
