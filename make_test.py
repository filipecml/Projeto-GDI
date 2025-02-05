import os
import glob

toposort = ['cargo.sql','pessoa.sql','tipo_quarto.sql','quarto.sql','reserva.sql','funcionario.sql','pagamento.sql']

# Lê todos os arquivos sql e os mescla em um único arquivo para teste.

folder='./db/'
file_extension='sql'
output_file = 'teste_oracle.sql'
files = glob.glob(os.path.join(folder, f'*.{file_extension}'))
    
with open(output_file, 'w', encoding='utf-8') as outfile:
    for file in toposort:
        fn = folder+os.path.basename(file)
        with open(fn, 'r', encoding='utf-8') as infile:
            outfile.write(infile.read())
            outfile.write('\n\n')

    for file in files:
        if os.path.basename(file)!='povoamento.sql' and os.path.basename(file) not in toposort:
            with open(file, 'r', encoding='utf-8') as infile:
                outfile.write(infile.read())
                outfile.write('\n\n')
    with open('db/povoamento.sql', 'r', encoding='utf-8') as infile:
        outfile.write(infile.read())
        outfile.write('\n\n')




