import pyperclip

string = ""

c = 'A'
for i in range(26):
	string += f"letters['{chr(ord(c) + i)}'] = letter{chr(ord(c) + i)}\n"

pyperclip.copy(string)
