# conexionOficial_final.py
import psycopg2
from psycopg2 import pool
import atexit
import threading

# Configuración de Supabase
CONFIG = {
    "host": "db.krvvmwbplewbcsncbwcg.supabase.co",
    "database": "postgres",
    "user": "postgres",
    "password": "spacaninopaola",
    "port": 5432
}

# Variables globales
pool_conexiones = None
app_activa = True
lock = threading.Lock()

def inicializar_pool():
    """Inicializa el pool de conexiones"""
    global pool_conexiones, app_activa
    try:
        pool_conexiones = pool.SimpleConnectionPool(
            minconn=1,
            maxconn=5,
            **CONFIG
        )
        app_activa = True
        return True
    except Exception as e:
        print(f"❌ Error conectando a Supabase: {e}")
        return False

def obtener_conexion():
    """Obtiene una conexión del pool"""
    global app_activa, pool_conexiones
    
    if not app_activa:
        raise ConnectionError("La aplicación se está cerrando")
    
    with lock:
        if pool_conexiones is None:
            if not inicializar_pool():
                raise ConnectionError("No se pudo conectar a la base de datos")
        
        try:
            conn = pool_conexiones.getconn()
            # ✅ CONFIGURACIÓN CRÍTICA: AUTOCOMMIT
            conn.autocommit = True
            
            # Verificación rápida
            with conn.cursor() as cursor:
                cursor.execute("SELECT 1;")
            return conn
            
        except Exception as e:
            print(f"⚠️ Error en conexión: {e}. Reconectando...")
            try:
                if pool_conexiones:
                    pool_conexiones.closeall()
            except:
                pass
            
            # Reintentar
            inicializar_pool()
            conn = pool_conexiones.getconn()
            conn.autocommit = True
            return conn

def devolver_conexion(conn):
    """Devuelve una conexión al pool"""
    global app_activa, pool_conexiones
    
    if conn is None:
        return
    
    if not app_activa or pool_conexiones is None:
        try:
            conn.close()
        except:
            pass
        return
    
    with lock:
        try:
            if not conn.closed:
                # Con autocommit=True, no necesitamos rollback
                pool_conexiones.putconn(conn)
        except:
            try:
                conn.close()
            except:
                pass

def ejecutar_consulta(consulta, parametros=None):
    """
    Ejecuta una consulta SQL de manera segura con autocommit.
    
    Args:
        consulta: String SQL
        parametros: Tupla con parámetros (opcional)
    
    Returns:
        Para SELECT: Lista de tuplas con resultados
        Para otros: Resultado escalar o mensaje
    """
    conn = None
    cursor = None
    
    try:
        conn = obtener_conexion()
        cursor = conn.cursor()
        
        print(f"🔍 [SQL] Ejecutando: {consulta[:100]}...")
        if parametros:
            print(f"🔍 [PARAMS] {parametros}")
        
        if parametros:
            cursor.execute(consulta, parametros)
        else:
            cursor.execute(consulta)
        
        # Obtener resultado
        if cursor.description:  # Si la consulta devuelve resultados
            resultado = cursor.fetchall()
            print(f"🔍 [RESULTADO] Filas: {len(resultado)}")
            return resultado
        else:
            print(f"🔍 [RESULTADO] Operación completada (sin datos retornados)")
            return True
            
    except psycopg2.Error as e:
        error_msg = f"❌ Error PostgreSQL: {e.pgerror}"
        print(error_msg)
        raise Exception(error_msg)
        
    except Exception as e:
        error_msg = f"❌ Error general: {type(e).__name__}: {e}"
        print(error_msg)
        raise e
        
    finally:
        if cursor:
            try:
                cursor.close()
            except:
                pass
        if conn:
            devolver_conexion(conn)

def cerrar_conexiones():
    """Cierra todas las conexiones al finalizar"""
    global app_activa, pool_conexiones
    
    with lock:
        app_activa = False
        if pool_conexiones:
            try:
                pool_conexiones.closeall()
            except:
                pass

# Inicializar al importar
inicializar_pool()
atexit.register(cerrar_conexiones)