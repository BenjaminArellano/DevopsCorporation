import { useState, useEffect } from 'react'
import axios from 'axios'
import './App.css'

function App() {
  const [empleados, setEmpleados] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  // ←←← CAMBIA ESTA URL cuando tu backend esté listo
  const API_URL = '/api/empleados'

  useEffect(() => {
    fetchEmpleados()
  }, [])

  const fetchEmpleados = async () => {
    try {
      setLoading(true)
      setError(null)
      
      const response = await axios.get(API_URL)
      setEmpleados(response.data)
      
    } catch (err) {
      console.error('Error al obtener empleados:', err)
      setError('No se pudo conectar con el backend. Verifica que el servidor esté corriendo.')

      // Datos de prueba (para que puedas ver la tabla aunque el backend no responda)
      setEmpleados([
        { id: 1, nombre: "Juan Pérez", cargo: "Desarrollador Senior" },
        { id: 2, nombre: "María López", cargo: "Diseñadora UX" },
        { id: 3, nombre: "Carlos Rodríguez", cargo: "Analista de Sistemas" },
        { id: 4, nombre: "Ana Martínez", cargo: "Project Manager" },
        { id: 5, nombre: "Luis Gómez", cargo: "DevOps Engineer" },
      ])
    } finally {
      setLoading(false)
    }
  }

  return (
    <>
      <div className="container">
        <h1>Gestión de Empleados</h1>
        <p className="subtitle">Demostración de conexión con Backend (Spring Boot)</p>

        <div className="card">
          <div className="header">
            <h2>Lista de Empleados</h2>
            <button onClick={fetchEmpleados} className="btn-refresh">
              Actualizar tabla
            </button>
          </div>

          {loading && <p className="loading">Cargando empleados desde el backend...</p>}

          {error && <p className="error">{error}</p>}

          {!loading && (
            <div className="table-container">
              <table>
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Nombre Completo</th>
                    <th>Cargo</th>
                  </tr>
                </thead>
                <tbody>
                  {empleados.length > 0 ? (
                    empleados.map((empleado) => (
                      <tr key={empleado.id}>
                        <td className="id-column">{empleado.id}</td>
                        <td>{empleado.nombre}</td>
                        <td className="cargo">{empleado.cargo}</td>
                      </tr>
                    ))
                  ) : (
                    <tr>
                      <td colSpan="3" className="no-data">
                        No hay empleados registrados
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </div>
    </>
  )
}

export default App