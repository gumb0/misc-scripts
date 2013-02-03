import os

dic = { 'а':'a', 'б':'b', 'в':'v', 'г':'g', 'д':'d', 'е':'e', 'ё':'yo', 'ж':'zh', 'з':'z', 'и':'i', 'й':'y', 'к':'k', 'л':'l', 
    'м':'m', 'н':'n', 'о':'o', 'п':'p', 'р':'r', 'с':'s', 'т':'t', 'у':'u', 'ф':'f', 'х':'h', 'ц':'ts', 'ч':'ch', 'ш':'sh', 
    'щ':'sh', 'ъ':'', 'ы':'i', 'ь':'', 'э':'e', 'ю':'yu', 'я':'ya' }

def transliterate(str):
    return ''.join([dic[c] if c in dic else dic[c.lower()].upper() if c.lower() in dic else c for c in str])

for file in os.listdir('.'):
    os.rename(file, transliterate(file))