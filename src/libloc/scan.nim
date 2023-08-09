import std/[strutils], filescan

const MAX_FILENAME_EXTENSION_FINDER_TRIES {.intdefine.} = 65536

type
  Language* = ref object of RootObj
    name*: string
    files*: int
    blankLoc*: int
    # commentLoc*: int
    codeLoc*: int

    totalLoc*: int

proc analyseFile*(fname: string): tuple[blank, code, total: int] =
  var
    fileContents = readFile(fname)
    analysis = (blank: 0, code: 0, total: 0)
  
  let lines = fileContents
    .splitLines()

  for line in lines:
    inc analysis.total
    if line.isEmptyOrWhitespace():
      inc analysis.blank
    else:
      inc analysis.code

  analysis

proc getLanguageByExtension*(fname: string): string =
  var 
    pos: int
    passedDot: bool = false
    ext: string

  while pos < fname.len:
    if not passedDot:
      if fname[pos] == '.' and pos > 0:
        passedDot = true
        inc pos
        continue
    else:
      ext &= fname[pos].toLowerAscii()

    inc pos
  
  # TODO(xTrayambak): turn this into a table
  if ext == "nim" or ext == "nims" or ext == "nimble":
    return "Nim"
  elif ext == "c":
    return "C"
  elif ext == "cpp" or ext == "cxx":
    return "C++"
  elif ext == "rs":
    return "Rust"
  elif ext == "js":
    return "JavaScript"
  elif ext == "ts":
    return "TypeScript"
  elif ext == "bf":
    return "Brainfuck"
  else:
    echo "EXT: " & ext
  
proc parse*(files: seq[string]): seq[Language] =
  var 
    languages: seq[Language] = @[]
  for file in files:
    let langName = getLanguageByExtension(file)
    var 
      language: Language
      alreadyExists: bool = false

    language = Language(
      name: langName,
      files: 0,
      blankLoc: 0,
      codeLoc: 0,
      totalLoc: 0
    )

    for lang in languages:
      if lang.name == langName:
        language = lang
        alreadyExists = true

    inc language.files

    let analysed = analyseFile(file)

    language.blankLoc += analysed.blank
    language.codeLoc += analysed.code
    language.totalLoc += analysed.total

    if not alreadyExists:
      languages.add(language)
    
  languages
