import csv
import sqlite3
import time 

# 1. Definir os caminhos dos ficheiros CSV e de base de dados SQLite
csv_file_path = 'bank-full.csv'
db_file_path = 'bank.db'

print("Iniciando a importacão dos dados do ficheiro CSV para a base de dados SQLite...")
inicio = time.time()

# 2. Conectar à base de dados SQLite (ou criar se nao existir)
conn = sqlite3.connect(db_file_path)
cursor = conn.cursor()

# 3. Criar a tabela na base de dados SQLite (se nao existir)
cursor.execute("DROP TABLE IF EXISTS clientes_campanha")
cursor.execute("""
CREATE TABLE clientes_campanha (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    age INTEGER,
    job TEXT,
    marital TEXT,
    education TEXT,
    default_credito TEXT, 
    balance INTEGER,
    housing TEXT,
    Loan TEXT,
    contact TEXT,
    day INTEGER,
    month TEXT,
    duration INTEGER,
    Campaign INTEGER,
    pdays INTEGER,
    previous INTEGER,
    poutcome TEXT,
    y TEXT
    )
    """)

# 4. Ler os dados do ficheiro CSV e inserir na tabela SQLite
rows = []
with open(csv_file_path,  'r' , encoding= 'utf-8') as csv_file:
    csv_reader = csv.DictReader(csv_file, delimiter=';')

    for row in csv_reader:
        if not row: # Ignorar Linhas vazias
            continue

        # Converte os numeoros em int e mantem os textos como string
        rows.append((
         int(row['age']) if row['age'] else None,
         row['job'],
         row['marital'],
         row['education'],
         row['default'],
         int(row['balance']) if row['balance'] else None,
         row['housing'],
         row['loan'],
         row['contact'],
         int(row['day']) if row['day'] else None,
         row['month'],
         int(row['duration']) if row['duration'] else None,
         int(row['campaign']) if row['campaign'] else None,
         int(row['pdays']) if row['pdays'] else None,
         int(row['previous']) if row['previous'] else None,
         row['poutcome'],
         row['y']
     ))

# Inserir todas as 45 mil linhas de uma vez na tabela SQLite (Batch insert)
cursor.executemany("""
INSERT INTO clientes_campanha (age, job, marital, education, default_credito, balance, housing, Loan, contact, day, month, duration, Campaign, pdays, previous, poutcome, y)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
""", rows)

conn.commit() # Salvar as alteracoes na base de daos

# 6. Validar quantas linhas foram salvas na tabela SQLite
cursor.execute("SELECT COUNT(*) FROM clientes_campanha")
total_rows = cursor.fetchone()[0]

conn.close() # FECHAR A CONEXAO COM A BASE DE DAOS 

tempo_total = time.time() - inicio 
print(f"Importacao concluida com sucesso! Total de linhas importadas: {total_rows} em {tempo_total:.2f} segundos.")
