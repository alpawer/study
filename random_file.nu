# створюємо папку, якщо її немає
if not ("./TestFiles" | path exists) { mkdir "./TestFiles" }

# очищаємо папку
ls "./TestFiles" | where { ($in.name | path type) == "file" } | each { rm $in.name }
print $"(ansi cyan) Folder is clear\n" 

# генеруємо випадкову кількість файлів
let magic_number = 12
print $"(ansi yellow) Generating (random int 1..$magic_number) files\n"

for i in 1..(random int 1..$magic_number) {
    $"Content number ($i)" | save -f ("./TestFiles" | path join $"file_($i).txt")
    print $"(ansi green)   made: file_($i).txt"
}

print ""

# рахуємо кількість файлів
let file_count = (
    ls "./TestFiles"
    | where { ($in.name | path type) == "file" }
    | length
)

print $"(ansi cyan) We found ($file_count) files"
if $file_count == $magic_number {
    print $"(ansi magenta) -------------------"
    print $"(ansi magenta) Ура Київ за ($magic_number) дні"
    print $"(ansi magenta) -------------------"
} else {
    print $"(ansi red) Amount of files is not equal to ($magic_number). I am sorry"
}
