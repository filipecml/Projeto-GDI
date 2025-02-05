import os
import glob



# Lê todos os arquivos sql e os mescla em um único arquivo para teste.

folder='.'
file_extension='sql'
output_file = 'teste_oracle.sql'
files = glob.glob(os.path.join(folder, f'*.{file_extension}'))
    
with open(output_file, 'w', encoding='utf-8') as outfile:
    for file in files:
        if os.path.basename(file)!='povoamento.sql':
            with open(file, 'r', encoding='utf-8') as infile:
                outfile.write(infile.read())
                outfile.write('\n\n')
    with open('povoamento.sql', 'r', encoding='utf-8') as infile:
        outfile.write(infile.read())
        outfile.write('\n\n')




