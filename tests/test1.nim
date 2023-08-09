import pretty, libloc

let x = getAllFiles(
  ".",
  @[],
  @[]
)

let lStats = parse(x)

print lStats
