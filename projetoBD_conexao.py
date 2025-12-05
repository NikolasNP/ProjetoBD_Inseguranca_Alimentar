import re

# -----------------------------------------------------------
#  DETECTAR AUTOMATICAMENTE O DRIVER (mysqlclient / connector)
# -----------------------------------------------------------
try:
    import MySQLdb as mysql_driver
    usando_mysqlclient = True
    print("✔ Driver detectado: mysqlclient (MySQLdb)")
except ImportError:
    import mysql.connector as mysql_driver
    usando_mysqlclient = False
    print("✔ Driver detectado: mysql-connector-python")



# -----------------------------------------------------------
#  LIMPEZA DO DUMP
# -----------------------------------------------------------
def limpar_dump(sql):
    linhas = sql.splitlines()
    comandos = []
    comando_atual = []
    dentro_bloco = False

    for linha in linhas:
        linha_strip = linha.strip()

        if linha_strip.startswith("/*!"):
            continue
        if linha_strip.startswith("--") or linha_strip.startswith("#"):
            continue
        if linha_strip.startswith("LOCK TABLES") or linha_strip.startswith("UNLOCK TABLES"):
            continue
        if "SET @saved" in linha_strip or "SET sql_mode" in linha_strip:
            continue
        if linha_strip.startswith("DELIMITER"):
            continue

        if re.search(r"\bBEGIN\b", linha_strip, re.IGNORECASE):
            dentro_bloco = True

        if dentro_bloco:
            comando_atual.append(linha)
            if re.search(r"\bEND\b\s*;", linha_strip, re.IGNORECASE):
                comandos.append("\n".join(comando_atual))
                comando_atual = []
                dentro_bloco = False
            continue

        comando_atual.append(linha)

        if linha_strip.endswith(";"):
            comandos.append("\n".join(comando_atual))
            comando_atual = []

    return comandos



# -----------------------------------------------------------
#  EXECUÇÃO DO DUMP
# -----------------------------------------------------------
def executar_dump(cursor, conexao, sql_dump):
    comandos = limpar_dump(sql_dump)

    print(f"➡ Total de comandos detectados após limpeza: {len(comandos)}")

    for comando in comandos:
        comando = comando.strip()
        if not comando:
            continue

        try:
            cursor.execute(comando)
        except Exception as e:
            print("\n❌ ERRO AO EXECUTAR COMANDO:")
            print(comando)
            print("Erro:", e)
            raise e

    conexao.commit()



# -----------------------------------------------------------
#  CONEXÃO (automática p/ o driver detectado)
# -----------------------------------------------------------
if usando_mysqlclient:
    conexao = mysql_driver.connect(
        host="localhost",
        user="root",
        passwd="negrao528&A",
        db="projeto_insegurancaalimentar",
    )
else:
    conexao = mysql_driver.connect(
        host="localhost",
        user="root",
        password="negrao528&A",
        database="projeto_insegurancaalimentar",
    )

cursor = conexao.cursor()



# -----------------------------------------------------------
#  DESATIVAR FOREIGN KEYS PARA EVITAR O ERRO 3730
# -----------------------------------------------------------
print("⏳ Desativando FOREIGN_KEY_CHECKS...")
cursor.execute("SET FOREIGN_KEY_CHECKS = 0;")
conexao.commit()



# -----------------------------------------------------------
#  EXECUTAR O DUMP
# -----------------------------------------------------------
with open("dump.sql", "r", encoding="utf-8") as f:
    sql_dump = f.read()

executar_dump(cursor, conexao, sql_dump)



# -----------------------------------------------------------
#  REATIVAR AS FKs
# -----------------------------------------------------------
cursor.execute("SET FOREIGN_KEY_CHECKS = 1;")
conexao.commit()



cursor.close()
conexao.close()

print("✔ Dump importado com sucesso!")

