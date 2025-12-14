# tkinter_spa_canino.py - VERSIÓN MÍNIMA (solo cambia la conexión)
import tkinter as tk
from tkinter import ttk, messagebox
from datetime import datetime
from conexionOficial import ejecutar_consulta  # ÚNICO CAMBIO NECESARIO

# ------------------ Funciones IDÉNTICAS a las tuyas, solo cambio en conexión ------------------
""""def registrar_cliente():
    nombre = entry_cliente_nombre.get()
    telefono = entry_cliente_telefono.get()
    direccion = entry_cliente_direccion.get()
    try:
        # SOLO ESTA LÍNEA CAMBIA:
        resultado = ejecutar_consulta("SELECT registrar_cliente(%s, %s, %s);", (nombre, telefono, direccion))
        # En lugar de: cur.execute(...); conn.commit(); resultado = cur.fetchone()[0]
        
        messagebox.showinfo("Resultado", f"{resultado}\nCliente: {nombre}, Tel: {telefono}, Dirección: {direccion}")
    except Exception as e:
        messagebox.showerror("Error", str(e))"""
def registrar_cliente():
    nombre = entry_cliente_nombre.get().strip()
    telefono = entry_cliente_telefono.get().strip()
    direccion = entry_cliente_direccion.get().strip()
    
    if not direccion:
        direccion = None
    
    if not nombre or not telefono:
        messagebox.showwarning("Advertencia", "Nombre y Teléfono son obligatorios")
        return
    
    try:
        # Obtener el resultado
        resultado = ejecutar_consulta(
            "SELECT registrar_cliente(%s, %s, %s);", 
            (nombre, telefono, direccion)
        )
        
        # El resultado es una lista con una tupla: [('texto',)]
        mensaje = resultado[0][0] if resultado else str(resultado)
        
        print(f"🔍 Mensaje recibido: '{mensaje}'")  # Para debug
        
        if mensaje.startswith("SUCCESS"):
            if "ID=" in mensaje:
                id_cliente = mensaje.split("ID=")[1]
                mensaje_final = f"✅ Cliente registrado exitosamente\nID: {id_cliente}"
            else:
                mensaje_final = "✅ " + mensaje.replace("SUCCESS:", "")
            
            messagebox.showinfo("Éxito", 
                f"{mensaje_final}\n"
                f"Nombre: {nombre}\n"
                f"Teléfono: {telefono}\n"
                f"Dirección: {direccion or 'No especificada'}")
            
            # Limpiar campos
            entry_cliente_nombre.delete(0, tk.END)
            entry_cliente_telefono.delete(0, tk.END)
            entry_cliente_direccion.delete(0, tk.END)
            
        elif mensaje.startswith("ERROR"):
            error_msg = mensaje.replace("ERROR:", "").strip()
            messagebox.showwarning("Advertencia", error_msg)
            
        else:
            # Para manejar versiones antiguas que solo devuelven 'OK'
            if mensaje == "OK":
                messagebox.showinfo("Éxito", 
                    f"✅ Cliente registrado\n"
                    f"Nombre: {nombre}\n"
                    f"Teléfono: {telefono}")
                
                # Limpiar campos
                entry_cliente_nombre.delete(0, tk.END)
                entry_cliente_telefono.delete(0, tk.END)
                entry_cliente_direccion.delete(0, tk.END)
            else:
                messagebox.showinfo("Resultado", mensaje)
                
    except Exception as e:
        print(f"❌ Error completo: {type(e).__name__}: {e}")
        messagebox.showerror("Error", f"No se pudo registrar cliente:\n\n{str(e)}")

def registrar_mascota():
    nombre = entry_mascota_nombre.get().strip()
    temperamento = entry_mascota_temperamento.get().strip()
    id_cliente = entry_mascota_id_cliente.get().strip()
    raza = entry_mascota_raza.get().strip()
    fecha_nac = entry_mascota_fecha.get().strip()

    # Validación básica de campos obligatorios
    if not nombre or not temperamento or not id_cliente:
        messagebox.showwarning("Advertencia", "Nombre, temperamento e ID de cliente son obligatorios.")
        return

    fecha_nac_val = None
    if fecha_nac:
        try:
            fecha_nac_val = datetime.strptime(fecha_nac, "%Y-%m-%d").date()
        except:
            messagebox.showwarning("Error", "La fecha debe tener el formato YYYY-MM-DD.")
            return

        # Validación de fecha futura o igual a hoy
        if fecha_nac_val >= datetime.today().date():
            messagebox.showerror("Error", "La fecha de nacimiento no puede ser futura ni de hoy.")
            return

    try:
        # Llamada a la función SQL
        resultado = ejecutar_consulta(
            "SELECT registrar_mascota(%s, %s, %s, %s, %s);",
            (nombre, temperamento, id_cliente, raza if raza else None, fecha_nac_val)
        )

        mensaje = resultado[0][0] if resultado else "Sin respuesta"

        # Extraer el ID si viene en formato "OK ID=###"
        id_mascota = None
        if "ID=" in mensaje:
            id_mascota = mensaje.split("ID=")[1].strip()

        # Construir mensaje para el usuario
        msg = "🐶 MASCOTA REGISTRADA CON ÉXITO\n\n"

        if id_mascota:
            msg += f"➡ ID Mascota: {id_mascota}\n"

        msg += (
            f"➡ Nombre: {nombre}\n"
            f"➡ Temperamento: {temperamento}\n"
            f"➡ ID Cliente: {id_cliente}\n"
            f"➡ Raza: {raza or 'No especificada'}\n"
            f"➡ Fecha Nac.: {fecha_nac or 'No especificada'}\n"
        )

        messagebox.showinfo("Mascota Registrada", msg)

        # Limpiar campos
        entry_mascota_nombre.delete(0, tk.END)
        entry_mascota_temperamento.delete(0, tk.END)
        entry_mascota_id_cliente.delete(0, tk.END)
        entry_mascota_raza.delete(0, tk.END)
        entry_mascota_fecha.delete(0, tk.END)

    except Exception as e:
        messagebox.showerror("Error", str(e))



def registrar_cita():
    fecha_hora = entry_cita_fecha.get().strip()
    id_mascota = entry_cita_id_mascota.get().strip()
    id_groomer = entry_cita_id_groomer.get().strip()
    id_recepcionista = entry_cita_id_recepcionista.get().strip()
    estado = entry_cita_estado.get().strip()
    nota = entry_cita_nota.get().strip()
    id_servicio = entry_cita_id_servicio.get().strip()

    # Validación básica de campos obligatorios
    if not fecha_hora or not id_mascota or not id_groomer or not id_recepcionista or not id_servicio:
        messagebox.showwarning("Advertencia", "Todos los campos obligatorios deben ser completados.")
        return

    try:
        # Convertir fecha/hora
        fecha_hora_val = datetime.strptime(fecha_hora, "%Y-%m-%d %H:%M:%S")

        # Ejecutar función SQL
        resultado = ejecutar_consulta(
            "SELECT registrar_cita(%s, %s, %s, %s, %s, %s, %s);",
            (fecha_hora_val,
             id_mascota,
             id_groomer,
             id_recepcionista,
             id_servicio,
             estado,
             nota if nota else None)
        )

        mensaje = resultado[0][0] if resultado else "Sin respuesta"

        # Revisar si hay error devuelto por la función SQL
        if mensaje.startswith("ERROR"):
            messagebox.showerror("Error al registrar cita", mensaje)
            return

        # Extraer el ID de la cita
        id_cita = None
        if "ID=" in mensaje:
            id_cita = mensaje.split("ID=")[1].strip()

        # Construir mensaje de confirmación
        msg = "📅 CITA REGISTRADA CON ÉXITO\n\n"

        if id_cita:
            msg += f"➡ ID de la cita: {id_cita}\n"
        else:
            msg += "➡ ID de la cita: (No recibido)\n"

        msg += (
            f"➡ ID Mascota: {id_mascota}\n"
            f"➡ ID Groomer: {id_groomer}\n"
            f"➡ ID Recepcionista: {id_recepcionista}\n"
            f"➡ ID Servicio: {id_servicio}\n"
            f"➡ Fecha y Hora: {fecha_hora}\n"
            f"➡ Estado: {estado}\n"
            f"➡ Nota: {nota or 'Sin nota'}\n"
        )

        messagebox.showinfo("Cita Registrada", msg)

        # Limpiar campos
        entry_cita_fecha.delete(0, tk.END)
        entry_cita_id_mascota.delete(0, tk.END)
        entry_cita_id_groomer.delete(0, tk.END)
        entry_cita_id_recepcionista.delete(0, tk.END)
        entry_cita_id_servicio.delete(0, tk.END)
        entry_cita_estado.delete(0, tk.END)
        entry_cita_nota.delete(0, tk.END)

    except Exception as e:
        messagebox.showerror("Error", str(e))



'''def agregar_servicio():
    id_cita = entry_servicio_id_cita.get()
    id_servicio = entry_servicio_id_servicio.get()
    cantidad = entry_servicio_cantidad.get() or 1
    try:
        # SOLO ESTA LÍNEA CAMBIA:
        resultado = ejecutar_consulta("SELECT agregar_servicio_a_cita(%s, %s, %s);",
                                     (id_cita, id_servicio, cantidad))
        
        messagebox.showinfo("Resultado", f"{resultado}\nServicio ID: {id_servicio} agregado a Cita ID: {id_cita}")
    except Exception as e:
        messagebox.showerror("Error", str(e))'''

def registrar_factura():
    id_cita = entry_factura_id_cita.get()
    total = entry_factura_total.get()
    metodo = entry_factura_metodo.get()
    try:
        # SOLO ESTA LÍNEA CAMBIA:
        resultado = ejecutar_consulta("SELECT registrar_factura(%s, %s, %s);", (id_cita, total, metodo))
        
        messagebox.showinfo("Resultado", f"{resultado}\nFactura para Cita ID: {id_cita}, Total: {total}, Método: {metodo}")
    except Exception as e:
        messagebox.showerror("Error", str(e))

def actualizar_estado():
    id_cita = entry_estado_id_cita.get()
    estado = entry_estado_nuevo.get()
    try:
        # SOLO ESTA LÍNEA CAMBIA:
        resultado = ejecutar_consulta("SELECT actualizar_estado_cita(%s, %s);", (id_cita, estado))
        
        messagebox.showinfo("Resultado", f"{resultado}\nCita ID: {id_cita} actualizada a estado: {estado}")
    except Exception as e:
        messagebox.showerror("Error", str(e))

def listar_citas_hoy():
    try:
        # SOLO ESTA LÍNEA CAMBIA:
        citas = ejecutar_consulta("SELECT * FROM listar_citas_hoy();")
        
        if not citas:
            messagebox.showinfo("Citas Hoy", "No hay citas para hoy.")
            return
        texto = ""
        for cita in citas:
            texto += f"ID: {cita[0]}, FechaHora: {cita[1]}, Estado: {cita[2]}, Cliente: {cita[3]}, Mascota: {cita[4]}, Groomer: {cita[5]}\n"
        messagebox.showinfo("Citas Hoy", texto)
    except Exception as e:
        messagebox.showerror("Error", str(e))

def ver_detalles():
    id_cita = entry_detalles_id_cita.get()
    try:
        # SOLO ESTA LÍNEA CAMBIA:
        detalles = ejecutar_consulta("SELECT * FROM ver_detalles_cita(%s);", (id_cita,))
        
        if not detalles:
            messagebox.showinfo("Detalles de Cita", "No se encontraron detalles para esta cita.")
            return
        texto = ""
        for det in detalles:
           texto += (f"ID Cita: {det[0]}\nFechaHora: {det[1]}\nEstado: {det[2]}\nNota: {det[3]}"
          f"\nCliente: {det[4]}\nMascota: {det[5]}\nGroomer: {det[6]}"
          f"\nServicio: {det[7]}\nPrecio: {det[8]}\n\n")

        messagebox.showinfo("Detalles de Cita", texto)
    except Exception as e:
        messagebox.showerror("Error", str(e))

# ------------------ Interfaz Tkinter EXACTAMENTE IGUAL ------------------
root = tk.Tk()
root.title("SPA Canino - Gestión")
root.geometry("600x650")

notebook = ttk.Notebook(root)
notebook.pack(expand=True, fill='both')

# --- Pestaña Cliente --- (EXACTAMENTE IGUAL)
tab_cliente = ttk.Frame(notebook)
notebook.add(tab_cliente, text="Cliente")
tk.Label(tab_cliente, text="Nombre:").grid(row=0, column=0)
entry_cliente_nombre = tk.Entry(tab_cliente); entry_cliente_nombre.grid(row=0, column=1)
tk.Label(tab_cliente, text="Teléfono:").grid(row=1, column=0)
entry_cliente_telefono = tk.Entry(tab_cliente); entry_cliente_telefono.grid(row=1, column=1)
tk.Label(tab_cliente, text="Dirección:").grid(row=2, column=0)
entry_cliente_direccion = tk.Entry(tab_cliente); entry_cliente_direccion.grid(row=2, column=1)
tk.Button(tab_cliente, text="Registrar Cliente", command=registrar_cliente).grid(row=3, column=0, columnspan=2)

# --- Pestaña Mascota --- (EXACTAMENTE IGUAL)
tab_mascota = ttk.Frame(notebook)
notebook.add(tab_mascota, text="Mascota")
tk.Label(tab_mascota, text="Nombre:").grid(row=0, column=0)
entry_mascota_nombre = tk.Entry(tab_mascota); entry_mascota_nombre.grid(row=0, column=1)
tk.Label(tab_mascota, text="Temperamento:").grid(row=1, column=0)
entry_mascota_temperamento = tk.Entry(tab_mascota); entry_mascota_temperamento.grid(row=1, column=1)
tk.Label(tab_mascota, text="ID Cliente:").grid(row=2, column=0)
entry_mascota_id_cliente = tk.Entry(tab_mascota); entry_mascota_id_cliente.grid(row=2, column=1)
tk.Label(tab_mascota, text="Raza:").grid(row=3, column=0)
entry_mascota_raza = tk.Entry(tab_mascota); entry_mascota_raza.grid(row=3, column=1)
tk.Label(tab_mascota, text="Fecha Nac (YYYY-MM-DD):").grid(row=4, column=0)
entry_mascota_fecha = tk.Entry(tab_mascota); entry_mascota_fecha.grid(row=4, column=1)
tk.Button(tab_mascota, text="Registrar Mascota", command=registrar_mascota).grid(row=5, column=0, columnspan=2)

# --- Pestaña Cita --- (EXACTAMENTE IGUAL)
# --- Pestaña Cita --- (MODIFICADA)
tab_cita = ttk.Frame(notebook)
notebook.add(tab_cita, text="Cita")

tk.Label(tab_cita, text="FechaHora (YYYY-MM-DD HH:MM:SS):").grid(row=0, column=0)
entry_cita_fecha = tk.Entry(tab_cita); entry_cita_fecha.grid(row=0, column=1)

tk.Label(tab_cita, text="ID Mascota:").grid(row=1, column=0)
entry_cita_id_mascota = tk.Entry(tab_cita); entry_cita_id_mascota.grid(row=1, column=1)

tk.Label(tab_cita, text="ID Groomer:").grid(row=2, column=0)
entry_cita_id_groomer = tk.Entry(tab_cita); entry_cita_id_groomer.grid(row=2, column=1)

tk.Label(tab_cita, text="ID Recepcionista:").grid(row=3, column=0)
entry_cita_id_recepcionista = tk.Entry(tab_cita); entry_cita_id_recepcionista.grid(row=3, column=1)

tk.Label(tab_cita, text="Estado:").grid(row=4, column=0)
entry_cita_estado = tk.Entry(tab_cita); entry_cita_estado.grid(row=4, column=1)

tk.Label(tab_cita, text="Nota:").grid(row=5, column=0)
entry_cita_nota = tk.Entry(tab_cita); entry_cita_nota.grid(row=5, column=1)

tk.Label(tab_cita, text="ID Servicio:").grid(row=6, column=0)
entry_cita_id_servicio = tk.Entry(tab_cita); entry_cita_id_servicio.grid(row=6, column=1)

tk.Button(tab_cita, text="Registrar Cita", command=registrar_cita).grid(row=7, column=0, columnspan=2)

# --- Pestaña Servicio --- (EXACTAMENTE IGUAL)
#tab_servicio = ttk.Frame(notebook)
#notebook.add(tab_servicio, text="Servicio a Cita")
#tk.Label(tab_servicio, text="ID Cita:").grid(row=0, column=0)
#tk.Label(tab_servicio, text="ID Servicio:").grid(row=1, column=0)
#entry_servicio_id_servicio = tk.Entry(tab_servicio); entry_servicio_id_servicio.grid(row=1, column=1)
#tk.Label(tab_servicio, text="Cantidad (1 por defecto):").grid(row=2, column=0)
#entry_servicio_cantidad = tk.Entry(tab_servicio); entry_servicio_cantidad.grid(row=2, column=1)
#tk.Button(tab_servicio, text="Agregar Servicio", command=agregar_servicio).grid(row=3, column=0, columnspan=2)

# --- Pestaña Factura --- (EXACTAMENTE IGUAL)
tab_factura = ttk.Frame(notebook)
notebook.add(tab_factura, text="Factura")
tk.Label(tab_factura, text="ID Cita:").grid(row=0, column=0)
entry_factura_id_cita = tk.Entry(tab_factura); entry_factura_id_cita.grid(row=0, column=1)
tk.Label(tab_factura, text="Total:").grid(row=1, column=0)
entry_factura_total = tk.Entry(tab_factura); entry_factura_total.grid(row=1, column=1)
tk.Label(tab_factura, text="Método (Tarjeta, QR, Efectivo):").grid(row=2, column=0)
entry_factura_metodo = tk.Entry(tab_factura); entry_factura_metodo.grid(row=2, column=1)
tk.Button(tab_factura, text="Registrar Factura", command=registrar_factura).grid(row=3, column=0, columnspan=2)

# --- Pestaña Actualizar Estado Cita --- (EXACTAMENTE IGUAL)
tab_estado = ttk.Frame(notebook)
notebook.add(tab_estado, text="Actualizar Estado Cita")
tk.Label(tab_estado, text="ID Cita:").grid(row=0, column=0)
entry_estado_id_cita = tk.Entry(tab_estado); entry_estado_id_cita.grid(row=0, column=1)
tk.Label(tab_estado, text="Nuevo Estado (Pendiente, Confirmada, Atendida, Cancelada):").grid(row=1, column=0)
entry_estado_nuevo = tk.Entry(tab_estado); entry_estado_nuevo.grid(row=1, column=1)
tk.Button(tab_estado, text="Actualizar Estado", command=actualizar_estado).grid(row=2, column=0, columnspan=2)

# --- Pestaña Citas de Hoy --- (EXACTAMENTE IGUAL)
tab_citas_hoy = ttk.Frame(notebook)
notebook.add(tab_citas_hoy, text="Citas de Hoy")
tk.Button(tab_citas_hoy, text="Ver Citas de Hoy", command=listar_citas_hoy).pack(pady=20)

# --- Pestaña Detalles Cita --- (EXACTAMENTE IGUAL)
tab_detalles = ttk.Frame(notebook)
notebook.add(tab_detalles, text="Detalles Cita")
tk.Label(tab_detalles, text="ID Cita:").grid(row=0, column=0)
entry_detalles_id_cita = tk.Entry(tab_detalles)
entry_detalles_id_cita.grid(row=0, column=1)
tk.Button(tab_detalles, text="Ver Detalles", command=ver_detalles).grid(row=1, column=0, columnspan=2, pady=10)

root.mainloop()