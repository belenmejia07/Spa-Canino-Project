# test_final.py
from conexionOficial import ejecutar_consulta

def test_final():
    print("=" * 60)
    print("PRUEBA FINAL - VERIFICACIÓN COMPLETA")
    print("=" * 60)
    
    try:
        # 1. Verificar datos existentes ANTES
        print("\n1. DATOS EXISTENTES ANTES DE LA PRUEBA:")
        datos_iniciales = ejecutar_consulta(
            "SELECT id_cliente, nombre, telefono FROM cliente ORDER BY id_cliente;"
        )
        print(f"   Total clientes iniciales: {len(datos_iniciales)}")
        for dato in datos_iniciales:
            print(f"   - ID: {dato[0]}, Nombre: {dato[1]}")
        
        # 2. Insertar nuevo cliente
        print("\n2. INSERTANDO NUEVO CLIENTE:")
        resultado = ejecutar_consulta(
            "SELECT registrar_cliente(%s, %s, %s);",
            ("Cliente Final Test", "999888777", "Dirección Final Test")
        )
        
        mensaje = resultado[0][0]
        print(f"   ✅ Función ejecutada: {mensaje}")
        
        if "SUCCESS" in mensaje:
            id_nuevo = mensaje.split("ID=")[1]
            print(f"   - ID generado: {id_nuevo}")
            
            # 3. Verificar inmediatamente
            print("\n3. VERIFICACIÓN INMEDIATA:")
            verif_inmediata = ejecutar_consulta(
                "SELECT nombre, telefono, fecharegistro FROM cliente WHERE id_cliente = %s;",
                (id_nuevo,)
            )
            
            if verif_inmediata:
                nombre, telefono, fecha = verif_inmediata[0]
                print(f"   ✅ ¡CLIENTE ENCONTRADO EN BD!")
                print(f"   - Nombre: {nombre}")
                print(f"   - Teléfono: {telefono}")
                print(f"   - Fecha: {fecha}")
            else:
                print("   ❌ Cliente NO encontrado (problema de COMMIT)")
                
            # 4. Verificar lista completa después
            print("\n4. LISTA COMPLETA DESPUÉS:")
            datos_finales = ejecutar_consulta(
                "SELECT id_cliente, nombre, telefono FROM cliente ORDER BY id_cliente;"
            )
            print(f"   Total clientes finales: {len(datos_finales)}")
            
            # Verificar que aumentó el conteo
            if len(datos_finales) > len(datos_iniciales):
                print(f"   ✅ ¡CONFIRMADO! El conteo aumentó de {len(datos_iniciales)} a {len(datos_finales)}")
                
                # Mostrar nuevo cliente
                for dato in datos_finales:
                    if dato[0] == int(id_nuevo):
                        print(f"   🔍 NUEVO CLIENTE EN BD:")
                        print(f"   - ID: {dato[0]}")
                        print(f"   - Nombre: {dato[1]}")
                        print(f"   - Teléfono: {dato[2]}")
            else:
                print("   ❌ El conteo NO aumentó")
                
            # 5. Limpiar prueba
            print("\n5. LIMPIANDO PRUEBA:")
            eliminados = ejecutar_consulta(
                "DELETE FROM cliente WHERE id_cliente = %s RETURNING nombre;",
                (id_nuevo,)
            )
            if eliminados:
                print(f"   ✅ Cliente de prueba eliminado: {eliminados[0][0]}")
            else:
                print("   ❌ No se pudo eliminar el cliente de prueba")
                
        else:
            print(f"   ❌ Error: {mensaje}")
            
    except Exception as e:
        print(f"\n❌ ERROR EN PRUEBA FINAL: {e}")

if __name__ == "__main__":
    test_final()