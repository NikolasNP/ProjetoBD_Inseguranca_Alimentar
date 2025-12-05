import mysql.connector

conexao = mysql.connector.connect(
    host="localhost",
    user="root",
    password="negrao528&A",
    database="projeto_insegurancaalimentar"
)

cursor = conexao.cursor()

cursor.execute("""SELECT * FROM usuario;""")
resultados = cursor.fetchall()

for linha in resultados:
    print(linha)


cursor.close()
conexao.close()
