import os
import random
from colorama import Fore, init

# Ініціалізація colorama (для Windows)
init(autoreset=True)

# Папка для файлів
folder_path = "./TestFiles"

# Якщо папки немає — створюємо
if not os.path.exists(folder_path):
    os.makedirs(folder_path)
    print(Fore.CYAN + f"folder '{folder_path}' was created.")

# Очищаємо папку від файлів
for filename in os.listdir(folder_path):
    file_path = os.path.join(folder_path, filename)
    if os.path.isfile(file_path):
        os.remove(file_path)
print(Fore.CYAN + "Folder is clear\n")

# Магічне число
magic_number = 12
random_count = random.randint(1, magic_number)

print(Fore.YELLOW + f"Generating {random_count} files\n")

# Генеруємо файли
for i in range(1, random_count + 1):
    file_name = f"file_{i}.txt"
    file_path = os.path.join(folder_path, file_name)
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(f"Content number {i}")
    print(Fore.GREEN + f"   made: {file_name}")

print()

# Рахуємо кількість файлів
file_count = len([f for f in os.listdir(folder_path) if os.path.isfile(os.path.join(folder_path, f))])

print(Fore.CYAN + f"We found {file_count} files")
if file_count == magic_number:
    print(Fore.MAGENTA + "----------------------")
    print(Fore.MAGENTA + f"Ура Київ за {magic_number} днів")
    print(Fore.MAGENTA + "----------------------")
else:
    print(Fore.RED + f"Amount of files is not equal to {magic_number}. I am sorry")
