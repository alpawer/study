# створюємо папку, якщо її немає
if not ("./TestFiles" | path exists) { mkdir "./TestFiles" }

# очищаємо папку
ls "./TestFiles" | where { ($in.name | path type) == "file" } | each { rm $in.name }
print $"(ansi cyan) Folder is clear\n" 

# генеруємо випадкову кількість файлів
print $"(ansi yellow) Generating (random int 1..5) files\n"

for i in 1..(random int 1..5) {
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

if $file_count == 3 {
    print $"(ansi magenta) -------------------"
    print $"(ansi magenta) Ура Київ за три дні"
    print $"(ansi magenta) -------------------"
} else {
    print $"(ansi red) Amount of files is not equal to 3. I am sorry"
}
