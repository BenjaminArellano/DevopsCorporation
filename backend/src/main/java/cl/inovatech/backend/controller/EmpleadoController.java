package cl.inovatech.backend.controller;

import java.util.List;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import cl.inovatech.backend.model.Empleado;
import cl.inovatech.backend.repository.EmpleadoRepository;

@RestController
@RequestMapping("/api/empleados")
@CrossOrigin("")
public class EmpleadoController {
    private final EmpleadoRepository repository;

    public EmpleadoController(EmpleadoRepository repository){
        this.repository=repository;
    }

    @GetMapping
    public List<Empleado> getEmpleados(){
        return repository.findAll();
    }
}
