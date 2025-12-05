import tkinter as tk
from tkinter import ttk, messagebox
import mysql.connector
from tkcalendar import DateEntry

def conectar():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="negrao528&A",
        database="projeto_insegurancaalimentar"
    )


def fazer_login():
    usuario = entry_usuario.get()
    senha = entry_senha.get()

    if not usuario or not senha:
        messagebox.showwarning("Erro", "Preencha todos os campos!")
        return

    try:
        conexao = conectar()
        cursor = conexao.cursor()
        sql = "SELECT perfil FROM Usuario WHERE nome_usuario = %s AND senha = %s"
        cursor.execute(sql, (usuario, senha))
        resultado = cursor.fetchone()

        if resultado:
            perfil = resultado[0]
            messagebox.showinfo("Login bem-sucedido", f"Bem-vindo, {usuario}! Perfil: {perfil}")
            root.destroy()
            abrir_painel(perfil)
        else:
            messagebox.showerror("Erro", "Usuário ou senha incorretos!")

    except mysql.connector.Error as erro:
        messagebox.showerror("Erro de conexão", f"Erro ao conectar com MySQL:\n{erro}")

    finally:
        if cursor:
            cursor.close()
        if conexao:
            conexao.close()

def consultar_relatorio_basico(conexao):
    """
    Retorna uma tupla (resultados, colunas).
    Fecha o cursor, mas NÃO fecha a conexão (opcional), porém vamos fechar a conexão no caller.
    """
    cursor = conexao.cursor()
    sql = "SELECT * FROM relatorio_basico;"
    cursor.execute(sql)
    resultados = cursor.fetchall()
    colunas = [desc[0] for desc in cursor.description] if cursor.description else []
    cursor.close()
    return resultados, colunas


def mostrar_relatorio_basico():
    try:
        conexao = conectar()
        resultados, colunas = consultar_relatorio_basico(conexao)
        conexao.close()
    except Exception as e:
        messagebox.showerror("Erro", f"Erro ao consultar o relatório básico:\n{e}")
        return

    # Criar janela para mostrar o relatório
    janela = tk.Toplevel()
    janela.title("Relatório Básico")
    janela.geometry("1000x500")

    frame = ttk.Frame(janela)
    frame.pack(fill=tk.BOTH, expand=True)

    scroll_y = ttk.Scrollbar(frame, orient=tk.VERTICAL)
    scroll_y.pack(side=tk.RIGHT, fill=tk.Y)

    scroll_x = ttk.Scrollbar(frame, orient=tk.HORIZONTAL)
    scroll_x.pack(side=tk.BOTTOM, fill=tk.X)

    tree = ttk.Treeview(
        frame,
        columns=colunas if colunas else ["col"],
        show="headings",
        yscrollcommand=scroll_y.set,
        xscrollcommand=scroll_x.set
    )
    tree.pack(fill=tk.BOTH, expand=True)

    scroll_y.config(command=tree.yview)
    scroll_x.config(command=tree.xview)

    # Configurar cabeçalhos
    if colunas:
        for col in colunas:
            tree.heading(col, text=col)
            tree.column(col, width=150, anchor=tk.W)
    else:
        tree.heading("col", text="Resultado")
        tree.column("col", width=800, anchor=tk.W)

    # Caso não tenha registros
    if len(resultados) == 0:
        messagebox.showinfo("Relatório Básico", "Nenhum dado encontrado no relatório.")
        return

    # Inserir linhas
    for linha in resultados:
        
        if colunas:
            tree.insert("", tk.END, values=list(linha))
        else:
            tree.insert("", tk.END, values=[str(linha)])





def abrir_painel(perfil):
    painel = tk.Tk()
    painel.title("Opções do Banco de Dados")
    painel.geometry("500x350")

    painel.columnconfigure(0, weight=1)
    painel.columnconfigure(1, weight=1)

    titulo = ttk.Label(painel, text="Opções do Banco de Dados", font=("Arial", 14, "bold"))
    titulo.grid(row=0, column=0, columnspan=2, pady=20)

    botao_inserir = ttk.Button(
        painel, text="Inserir/Atualizar", width=20,
        command=lambda: abrir_inserir_atualizar(perfil, painel)
    )
    botao_inserir.grid(row=1, column=1, padx=10, pady=10)
    
    botao_relatorio = ttk.Button(
        painel,
        text="Relatório Básico",
        width=20,
        command=mostrar_relatorio_basico
    )
    botao_relatorio.grid(row=3, column=1, padx=10, pady=10)


    botao_consultar = ttk.Button(
        painel,
        text="Consultar",
        width=20,
        command=lambda: abrir_consultar(painel, perfil)
    )

    botao_consultar.grid(row=2, column=1, padx=10, pady=10)

    botao_voltar = ttk.Button(painel, text="Sair", width=15, command=painel.destroy)
    botao_voltar.grid(row=4, column=1, pady=30)

    painel.mainloop()

def abrir_inserir_atualizar(perfil, janela_anterior):
    if perfil not in ["Administrador", "Pesquisador"]:
        messagebox.showerror("Acesso negado", "Você não tem permissão para acessar esta área!")
        return

    janela_anterior.destroy()
    tela = tk.Tk()
    tela.title("Inserir / Atualizar / Deletar")
    tela.geometry("650x600")

    lbl_titulo = ttk.Label(tela, text="Inserir / Atualizar / Deletar", font=("Arial", 14, "bold"))
    lbl_titulo.pack(pady=10)

    frame = ttk.Frame(tela, padding=20, relief="solid")
    frame.pack(fill=tk.BOTH, expand=True, padx=20, pady=10)

    ttk.Label(frame, text="Selecionar Tabela:").grid(row=0, column=0, sticky=tk.W)

    conexao = conectar()
    cursor = conexao.cursor()
    cursor.execute("SHOW TABLES")
    tabelas = [t[0] for t in cursor.fetchall()]
    conexao.close()

    tabela_selecionada = tk.StringVar()
    menu_tabelas = ttk.Combobox(frame, textvariable=tabela_selecionada, values=tabelas, state="readonly")
    menu_tabelas.grid(row=0, column=1, padx=10)

    campos_entries = []
    primary_key_name = None  # será descoberta no DESCRIBE

    def carregar_campos():
        nonlocal primary_key_name

        for widget in frame.winfo_children()[2:]:
            widget.destroy()

        try:
            conexao = conectar()
            cursor = conexao.cursor()
            cursor.execute(f"DESCRIBE {tabela_selecionada.get()}")
            colunas = cursor.fetchall()
        finally:
            conexao.close()

        ttk.Label(frame, text="\nInserir / Atualizar Dados:", font=("Arial", 10, "bold")).grid(row=1, column=0, sticky=tk.W, pady=5)

        campos_entries.clear()

        # Identificar PK (primeira coluna)
        primary_key_name = colunas[0][0]

        for i, col in enumerate(colunas):
            ttk.Label(frame, text=f"{col[0]}:").grid(row=i+2, column=0, sticky=tk.W, pady=3)
            campo = ttk.Entry(frame, width=30)
            campo.grid(row=i+2, column=1, padx=10, pady=3)
            campos_entries.append((col[0], campo))

        # Botões
        btn_salvar = ttk.Button(frame, text="Confirmar Inserir/Atualizar", command=salvar_dados)
        btn_salvar.grid(row=len(colunas)+3, column=1, pady=15, sticky=tk.E)

        btn_deletar = ttk.Button(frame, text="Deletar por ID", command=deletar_registro)
        btn_deletar.grid(row=len(colunas)+4, column=1, pady=5, sticky=tk.E)

        btn_voltar = ttk.Button(frame, text="Voltar", command=lambda: voltar_para_painel(tela, perfil))
        btn_voltar.grid(row=len(colunas)+5, column=0, pady=15, sticky=tk.W)

    # FUNÇÃO SALVAR (INSERT / UPDATE)
    def salvar_dados():
        tabela = tabela_selecionada.get()
        if not tabela:
            messagebox.showwarning("Aviso", "Selecione uma tabela!")
            return

        dados = {coluna: campo.get() for coluna, campo in campos_entries}

        primary_key = list(dados.keys())[0]
        primary_value = dados[primary_key].strip()

        try:
            conexao = conectar()
            cursor = conexao.cursor()

            # Se ID informado → verificar se existe
            if primary_value != "":
                cursor.execute(
                    f"SELECT COUNT(*) FROM {tabela} WHERE {primary_key} = %s",
                    (primary_value,)
                )
                existe = cursor.fetchone()[0]

                if existe > 0:
                    # UPDATE
                    colunas_update = ", ".join(
                        [f"{col} = %s" for col in dados.keys() if col != primary_key]
                    )
                    valores = tuple(dados[col] for col in dados.keys() if col != primary_key)
                    valores += (primary_value,)

                    sql = f"UPDATE {tabela} SET {colunas_update} WHERE {primary_key} = %s"
                    cursor.execute(sql, valores)
                    conexao.commit()

                    messagebox.showinfo("Sucesso", "Dados atualizados com sucesso!")
                    return

            # Caso contrário, INSERT
            colunas_sql = ", ".join(dados.keys())
            valores_sql = ", ".join(["%s"] * len(dados))

            cursor.execute(
                f"INSERT INTO {tabela} ({colunas_sql}) VALUES ({valores_sql})",
                tuple(dados.values())
            )
            conexao.commit()

            messagebox.showinfo("Sucesso", "Dados inseridos com sucesso!")

        except mysql.connector.Error as erro:
            messagebox.showerror("Erro", f"Erro ao salvar dados:\n{erro}")

        finally:
            conexao.close()

    # FUNÇÃO DELETAR 
    def deletar_registro():
        tabela = tabela_selecionada.get()
        if not tabela:
            messagebox.showwarning("Aviso", "Selecione uma tabela!")
            return

        # ID está no primeiro campo sempre
        primary_value = campos_entries[0][1].get().strip()

        if primary_value == "":
            messagebox.showwarning("Aviso", f"Para deletar, informe o ID ({primary_key_name})!")
            return

        try:
            conexao = conectar()
            cursor = conexao.cursor()

            # Verifica se existe
            cursor.execute(
                f"SELECT COUNT(*) FROM {tabela} WHERE {primary_key_name} = %s",
                (primary_value,)
            )
            existe = cursor.fetchone()[0]

            if existe == 0:
                messagebox.showwarning("Aviso", f"Nenhum registro encontrado com ID = {primary_value}.")
                return

            # Confirmação
            confirm = messagebox.askyesno("Confirmar", f"Deseja realmente deletar o registro com ID {primary_value}?")
            if not confirm:
                return

            # DELETE
            cursor.execute(
                f"DELETE FROM {tabela} WHERE {primary_key_name} = %s",
                (primary_value,)
            )
            conexao.commit()

            messagebox.showinfo("Sucesso", "Registro deletado com sucesso!")

            # Limpar campos
            for _, campo in campos_entries:
                campo.delete(0, tk.END)

        except mysql.connector.Error as erro:
            messagebox.showerror("Erro", f"Erro ao deletar registro:\n{erro}")

        finally:
            conexao.close()

    # ----------------------------------------------------
    menu_tabelas.bind("<<ComboboxSelected>>", lambda e: carregar_campos())
    tela.mainloop()



def abrir_consultar(janela_anterior, perfil):
    # fecha painel anterior
    janela_anterior.destroy()

    tela = tk.Tk()
    tela.title("Consultar Banco de Dados")
    tela.geometry("1100x650")  

    # Configurar estilo
    style = ttk.Style()
    style.theme_use('clam')
    style.configure('Titulo.TLabel', font=('Arial', 16, 'bold'))
    style.configure('Rotulo.TLabel', font=('Arial', 10))
    style.configure('Botao.TButton', font=('Arial', 10))

    frame_principal = ttk.Frame(tela, padding="12")
    frame_principal.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
    frame_principal.columnconfigure(0, weight=1)
    frame_principal.rowconfigure(4, weight=1)

    titulo = ttk.Label(frame_principal, text="Consultar", style='Titulo.TLabel')
    titulo.grid(row=0, column=0, columnspan=4, pady=(0, 10))

    # Frame tabela e combobox
    frame_tabela = ttk.LabelFrame(frame_principal, text="Selecionar Tabela:", padding="8")
    frame_tabela.grid(row=1, column=0, columnspan=4, sticky=(tk.W, tk.E), pady=(0, 10))

    combo_tabela = ttk.Combobox(frame_tabela, width=60, state='readonly')
    combo_tabela.grid(row=0, column=0, padx=(0, 10))

    btn_carregar = ttk.Button(frame_tabela, text="Carregar Tabelas", style='Botao.TButton')
    btn_carregar.grid(row=0, column=1)

    # Frame filtros (dinâmicos)
    frame_filtros = ttk.LabelFrame(frame_principal, text="Filtros (preencha os campos desejados)", padding="10")
    frame_filtros.grid(row=2, column=0, columnspan=4, sticky=(tk.W, tk.E), pady=(0, 10))
    

    # Botões
    frame_botoes = ttk.Frame(frame_principal)
    frame_botoes.grid(row=3, column=0, columnspan=4, pady=8)

    btn_consultar = ttk.Button(frame_botoes, text="Consultar", style='Botao.TButton', width=18)
    btn_consultar.grid(row=0, column=0, padx=6)

    btn_limpar = ttk.Button(frame_botoes, text="Limpar Filtros", style='Botao.TButton', width=18)
    btn_limpar.grid(row=0, column=1, padx=6)

    btn_visualizar = ttk.Button(frame_botoes, text="Visualizar Tabela", style='Botao.TButton', width=18)
    btn_visualizar.grid(row=0, column=2, padx=6)

    btn_voltar = ttk.Button(
        frame_botoes,
        text="Voltar",
        style='Botao.TButton',
        width=18,
        command=lambda: voltar_para_painel(tela, perfil)
    )
    btn_voltar.grid(row=0, column=3, padx=6)

    # Area resultados
    frame_resultados = ttk.LabelFrame(frame_principal, text="Resultados", padding="8")
    frame_resultados.grid(row=4, column=0, columnspan=4, sticky=(tk.W, tk.E, tk.N, tk.S))
    frame_resultados.columnconfigure(0, weight=1)
    frame_resultados.rowconfigure(0, weight=1)

    scroll_y = ttk.Scrollbar(frame_resultados, orient=tk.VERTICAL)
    scroll_y.grid(row=0, column=1, sticky=(tk.N, tk.S))

    scroll_x = ttk.Scrollbar(frame_resultados, orient=tk.HORIZONTAL)
    scroll_x.grid(row=1, column=0, sticky=(tk.W, tk.E))

    tree_resultados = ttk.Treeview(frame_resultados, yscrollcommand=scroll_y.set, xscrollcommand=scroll_x.set)
    tree_resultados.grid(row=0, column=0, sticky=(tk.N, tk.S, tk.E, tk.W))

    scroll_y.config(command=tree_resultados.yview)
    scroll_x.config(command=tree_resultados.xview)

    # Dicionários para widgets e meta-info dos filtros
    campos_filtro = {}        # coluna -> widget (Entry/Combobox) para valor principal
    operadores_filtro = {}    # coluna -> Combobox operador (para numéricos)
    intervalo_filtro = {}     # coluna -> segundo widget (Entry ou tuple de DateEntry)
    tipos_filtro = {}         # coluna -> tipo SQL retornado por DESCRIBE

    # Funções auxiliares de BD
    def carregar_tabelas():
        try:
            conexao = conectar()
            cursor = conexao.cursor()
            cursor.execute("SHOW TABLES")
            tabelas = [t[0] for t in cursor.fetchall()]
            conexao.close()

            combo_tabela['values'] = tabelas
            if tabelas:
                combo_tabela.current(0)
                atualizar_filtros()
        except Exception as e:
            messagebox.showerror("Erro", f"Erro ao carregar tabelas: {e}")

    def get_table_columns(tabela):
        """
        Retorna lista de tuplas (nome_coluna, tipo_em_minusculo) a partir de DESCRIBE.
        """
        try:
            conexao = conectar()
            cursor = conexao.cursor()
            cursor.execute(f"DESCRIBE `{tabela}`")
            rows = cursor.fetchall()
            conexao.close()
            # rows: (Field, Type, Null, Key, Default, Extra)
            return [(r[0], r[1].lower()) for r in rows]
        except Exception as e:
            messagebox.showerror("Erro", f"Erro ao obter colunas: {e}")
            return []

    def listar_valores_distintos(tabela, coluna, limite=200):
        """
        Busca valores distintos para autocomplete (limita para desempenho).
        Retorna lista de strings.
        """
        try:
            conexao = conectar()
            cursor = conexao.cursor()
            # LIMIT usado para evitar trazer milhões de linhas
            query = f"SELECT DISTINCT `{coluna}` FROM `{tabela}` WHERE `{coluna}` IS NOT NULL LIMIT {limite}"
            cursor.execute(query)
            vals = [str(r[0]) for r in cursor.fetchall() if r[0] is not None]
            conexao.close()
            return vals
        except Exception:
            return []

    # Função que cria filtros dinâmicos conforme tipo da coluna
    def atualizar_filtros(event=None):
        # limpar widgets anteriores
        for w in frame_filtros.winfo_children():
            w.destroy()

        tabela = combo_tabela.get()
        if not tabela:
            return

        colunas = get_table_columns(tabela)

        campos_filtro.clear()
        operadores_filtro.clear()
        intervalo_filtro.clear()
        tipos_filtro.clear()

        # cabeçalho da grade de filtros
        ttk.Label(frame_filtros, text="Coluna", style='Rotulo.TLabel').grid(row=0, column=0, sticky=tk.W, padx=4, pady=4)
        ttk.Label(frame_filtros, text="Operador/Valores", style='Rotulo.TLabel').grid(row=0, column=1, sticky=tk.W, padx=4, pady=4)
        ttk.Label(frame_filtros, text="Valor 1", style='Rotulo.TLabel').grid(row=0, column=2, sticky=tk.W, padx=4, pady=4)
        ttk.Label(frame_filtros, text="Valor 2 (se aplicável)", style='Rotulo.TLabel').grid(row=0, column=3, sticky=tk.W, padx=4, pady=4)

        for i, (col, tipo) in enumerate(colunas, start=1):
            tipos_filtro[col] = tipo

            # label da coluna
            ttk.Label(frame_filtros, text=col + ":", style='Rotulo.TLabel').grid(row=i, column=0, sticky=tk.W, padx=4, pady=4)

            # TIPOS NUMÉRICOS
            if any(k in tipo for k in ("int", "decimal", "numeric", "float", "double")):
                op = ttk.Combobox(frame_filtros, values=["=", ">", "<", ">=", "<=", "BETWEEN"], width=10, state="readonly")
                op.grid(row=i, column=1, padx=4, pady=4)
                op.current(0)

                entry1 = ttk.Entry(frame_filtros, width=18)
                entry1.grid(row=i, column=2, padx=4, pady=4)

                entry2 = ttk.Entry(frame_filtros, width=18)
                entry2.grid(row=i, column=3, padx=4, pady=4)

                operadores_filtro[col] = op
                campos_filtro[col] = entry1
                intervalo_filtro[col] = entry2

            # TIPOS DATA / DATETIME / TIMESTAMP
            elif any(k in tipo for k in ("date", "timestamp", "datetime", "time")):
                # usamos DateEntry do tkcalendar
                # data_pattern yyyy-mm-dd para compatibilidade com MySQL
                try:
                    d1 = DateEntry(frame_filtros, width=14, date_pattern="yyyy-mm-dd")
                    d2 = DateEntry(frame_filtros, width=14, date_pattern="yyyy-mm-dd")
                except Exception:
                    # fallback para Entry caso tkcalendar não esteja disponível (mas instruímos a instalar)
                    d1 = ttk.Entry(frame_filtros, width=18)
                    d2 = ttk.Entry(frame_filtros, width=18)

                d1.grid(row=i, column=2, padx=4, pady=4)
                d2.grid(row=i, column=3, padx=4, pady=4)

                campos_filtro[col] = None
                operadores_filtro[col] = None
                intervalo_filtro[col] = (d1, d2)

            # TIPOS TEXTO: COMBOBOX COM AUTOCOMPLETE (valores distintos)
            elif any(k in tipo for k in ("char", "text", "varchar", "enum")):
                # preenche a combobox com valores distintos (limitado)
                valores_distintos = listar_valores_distintos(tabela, col, limite=200)
                combo_val = ttk.Combobox(frame_filtros, values=valores_distintos, width=30)
                combo_val.grid(row=i, column=2, padx=4, pady=4, sticky=tk.W)
                # deixamos também um entry invisível em campos_filtro (apontando para o combobox)
                campos_filtro[col] = combo_val
                operadores_filtro[col] = None
                intervalo_filtro[col] = None

                # Observação: o Combobox permite digitar e escolher — comportamento de autocomplete simples

            # OUTROS TIPOS: entrada simples
            else:
                e = ttk.Entry(frame_filtros, width=30)
                e.grid(row=i, column=2, padx=4, pady=4)
                campos_filtro[col] = e
                operadores_filtro[col] = None
                intervalo_filtro[col] = None

    # Executa a consulta montando WHERE a partir dos filtros preenchidos
    def executar_consulta():
        tabela = combo_tabela.get()
        if not tabela:
            messagebox.showwarning("Aviso", "Selecione uma tabela primeiro!")
            return

        filtros = []
        valores = []

        for col, tipo in tipos_filtro.items():

            # NUMÉRICOS
            if col in operadores_filtro and operadores_filtro[col] is not None:
                op = operadores_filtro[col].get()
                v1 = campos_filtro[col].get().strip() if campos_filtro[col] is not None else ""
                v2 = intervalo_filtro[col].get().strip() if intervalo_filtro[col] is not None else ""

                if v1 != "":
                    if op == "BETWEEN":
                        if v2 == "":
                            messagebox.showwarning("Aviso", f"Informe o segundo valor para BETWEEN em '{col}'.")
                            return
                        filtros.append(f"`{col}` BETWEEN %s AND %s")
                        valores.extend([v1, v2])
                    else:
                        filtros.append(f"`{col}` {op} %s")
                        valores.append(v1)

            # DATAS
            elif col in intervalo_filtro and isinstance(intervalo_filtro[col], tuple) and intervalo_filtro[col] is not None:
                d1_widget, d2_widget = intervalo_filtro[col]
                # DateEntry tem método get_date(); Entry fallback usa get()
                try:
                    d1 = d1_widget.get_date()
                    d2 = d2_widget.get_date()
                    # garantir ordem
                    if d1 and d2:
                        filtros.append(f"`{col}` BETWEEN %s AND %s")
                        valores.append(str(d1))
                        valores.append(str(d2))
                except Exception:
                    # fallback: usar get() se não for DateEntry
                    d1s = d1_widget.get().strip()
                    d2s = d2_widget.get().strip()
                    if d1s and d2s:
                        filtros.append(f"`{col}` BETWEEN %s AND %s")
                        valores.append(d1s)
                        valores.append(d2s)

            # TEXT/CHAR/COMBOBOX (LIKE)
            else:
                widget = campos_filtro.get(col)
                if widget is None:
                    continue
                # Combobox e Entry têm .get()
                val = widget.get().strip()
                if val != "":
                    # usamos LIKE para texto (busca parcial)
                    filtros.append(f"`{col}` LIKE %s")
                    valores.append(f"%{val}%")

        sql = f"SELECT * FROM `{tabela}`"
        if filtros:
            sql += " WHERE " + " AND ".join(filtros)

        try:
            conexao = conectar()
            cursor = conexao.cursor()
            cursor.execute(sql, tuple(valores))
            resultados = cursor.fetchall()
            col_names = [desc[0] for desc in cursor.description]
            conexao.close()

            # exibir resultados na treeview
            tree_resultados.delete(*tree_resultados.get_children())
            tree_resultados["columns"] = col_names
            tree_resultados["show"] = "headings"

            for c in col_names:
                tree_resultados.heading(c, text=c)
                tree_resultados.column(c, width=140, anchor=tk.W)

            for row in resultados:
                # transformar tupla em lista para evitar problemas com objetos não-string
                tree_resultados.insert("", tk.END, values=list(row))

            messagebox.showinfo("Sucesso", f"Consulta executada. {len(resultados)} registros encontrados.")
        except Exception as e:
            messagebox.showerror("Erro", f"Erro na consulta: {e}")

    # Visualizar tabela completa (sem filtros)
    def visualizar_tabela():
        tabela = combo_tabela.get()
        if not tabela:
            messagebox.showwarning("Aviso", "Selecione uma tabela primeiro!")
            return
        try:
            conexao = conectar()
            cursor = conexao.cursor()
            cursor.execute(f"SELECT * FROM `{tabela}`")
            resultados = cursor.fetchall()
            col_names = [desc[0] for desc in cursor.description]
            conexao.close()

            tree_resultados.delete(*tree_resultados.get_children())
            tree_resultados["columns"] = col_names
            tree_resultados["show"] = "headings"
            for c in col_names:
                tree_resultados.heading(c, text=c)
                tree_resultados.column(c, width=140, anchor=tk.W)

            for row in resultados:
                tree_resultados.insert("", tk.END, values=list(row))

            messagebox.showinfo("Sucesso", f"Tabela completa carregada. {len(resultados)} registros.")
        except Exception as e:
            messagebox.showerror("Erro", f"Erro ao visualizar tabela: {e}")

    def limpar_filtros():
        # tenta limpar todos os widgets criados dinamicamente
        for col, widget in campos_filtro.items():
            try:
                if widget is None:
                    continue
                widget.set('') if isinstance(widget, ttk.Combobox) else widget.delete(0, tk.END)
            except Exception:
                # fallback genérico
                try:
                    widget.delete(0, tk.END)
                except Exception:
                    pass

        for col, op in operadores_filtro.items():
            try:
                if op is not None:
                    op.current(0)
            except Exception:
                pass

        # limpar date entries (se houver)
        for col, item in intervalo_filtro.items():
            if isinstance(item, tuple) and item is not None:
                w1, w2 = item
                try:
                    # DateEntry tem set_date; em fallback Entry usamos delete
                    w1.set_date(w1.get_date())
                    w2.set_date(w2.get_date())
                except Exception:
                    try:
                        w1.delete(0, tk.END)
                        w2.delete(0, tk.END)
                    except Exception:
                        pass

    def voltar():
        tela.destroy()
        abrir_painel(perfil)

    # ligar botões
    btn_carregar.config(command=carregar_tabelas)
    btn_consultar.config(command=executar_consulta)
    btn_limpar.config(command=limpar_filtros)
    btn_visualizar.config(command=visualizar_tabela)

    # atualizar filtros ao selecionar outra tabela manualmente
    combo_tabela.bind("<<ComboboxSelected>>", atualizar_filtros)

    # carregar tabelas inicial
    carregar_tabelas()

    tela.mainloop()




def voltar_para_painel(tela_atual, perfil):
    tela_atual.destroy()
    abrir_painel(perfil)


def criar_tela_login():
    global root, entry_usuario, entry_senha

    root = tk.Tk()
    root.title("Login")
    root.geometry("400x250")

    ttk.Label(root, text="Usuário:").grid(column=0, row=1, sticky=tk.E, padx=10, pady=5)
    entry_usuario = ttk.Entry(root, width=25)
    entry_usuario.grid(column=1, row=1, sticky=tk.W, padx=10, pady=5)

    ttk.Label(root, text="Senha:").grid(column=0, row=2, sticky=tk.E, padx=10, pady=5)
    entry_senha = ttk.Entry(root, width=25, show="*")
    entry_senha.grid(column=1, row=2, sticky=tk.W, padx=10, pady=5)

    ttk.Button(root, text="Entrar", command=fazer_login).grid(column=1, row=3, pady=10)

    root.mainloop()


criar_tela_login()
