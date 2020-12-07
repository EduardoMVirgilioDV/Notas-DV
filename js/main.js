$(function() {
    // Capturamos los elementos que necesitamos.
    var listaNotas = $('#lista-notas');
    var formNuevaNota = $('#form-nueva-nota');
    var inputCarrera = $('#carrera');
    var inputMateria = $('#materia');
    var inputInstancia = $('#instancia');
    var inputFecha = $('#fecha');
    var inputNota = $('#nota');
    var inputComentarios = $('#comentarios');
    var status = $('#status');
    var buttonOrdernarNotas = $('#lista-notas-ordenar');
    
    // Cargamos los datos de las carreras y de las materias.
    cargarCarreras();
    cargarMaterias();
    
    // Llamamos a la petición de ajax para traer todas las notas.
    $.ajax({
        // Cuando suban los php a un hosting...
//        url: 'http://www.sitio.com/api/traer-notas.php',
        // Pero localmente, apuntamos a alguna carpeta.
        url: 'http://localhost/santiago/api/traer-notas.php',
        type: 'GET',
        success: function(rta) {
            // Llamamos a la función para que arme la lista de notas.
            recrearListaNotas(rta);
        }
    });
    
    // Agregamos el evento.
    formNuevaNota.on('submit', function(ev) {
        ev.preventDefault();
        
        // Hacemos la petición de ajax al backend.
        $.ajax({
            // Cuando suban los php a un hosting...
//            url: 'http://www.sitio.com/api/grabar-nota.php',
            // Pero localmente, apuntamos a alguna carpeta.
            url: 'http://localhost/santiago/api/grabar-nota.php',
            // Como la acción es un alta, la petición es por POST.
            type: 'POST',
            // Los datos por POST viajan prácticamente igual que como lo
            // harían por GET. Es decir, vamos a escribir un string con el
            // formato:
            // name=valor&nameOtro=valorOtro&nameOtroMas=valorOtroMas
            // Los nombres deben ser los mismos que capturamos en el php.
            data: `materia=${inputMateria.val()}&instancia=${inputInstancia.val()}&fecha=${inputFecha.val()}&nota=${inputNota.val()}&comentarios=${inputComentarios.val()}`,
            
            success: function(rta) {
                // Preguntamos si tuvimos éxito...
                if(rta.success) {
                    // Armamos el template que queremos generar, con los
                    // datos del form.
                    var contenido = `<article class="nota">
                        <h3 class="nota-titulo">${inputInstancia.val()} - ${inputCarrera.val()} - ${inputMateria.val()}</h3>
                        <p class="nota-fecha">Fecha: ${inputFecha.val()}</p>
                        <p class="nota-nota">Nota: ${inputNota.val()}</p>
                        <p class="nota-comentarios">Comentarios: ${inputComentarios.val()}</p>
                        <button class="nota-eliminar ui-btn ui-shadow ui-corner-all">Eliminar</button>
                    </article>`;

                    // Transformamos el contenido a un elemento extendido
                    // por jQuery.
                    contenido = $(contenido);

                    // Inyectamos la nota al listado.
                    listaNotas.append(contenido);
                    
                    // Vaciamos los campos del form.
                    // TODO: Vaciar los <select> del form.
                    inputNota.val('');
                    inputFecha.val('');
                    inputComentarios.val('');
                    
                    // Ventanita de éxito.
                    $.confirm({
                        title: 'Éxito!',
                        content: 'La nota se agregó exitosamente.',
                        type: 'green',
                        escapeKey: 'quedarme',
                        buttons: {
                            quedarme: {
                                text: 'Seguir cargando',
                                action: function() {}
                            },
                            irAListado: {
                                text: 'Ir al listado',
                                btnClass: 'btn-blue',
                                // action lleva la acción a ejecutar cuando
                                // se apriete el botón.
                                action: function() {
                                    // Redireccionamos al usuario al listado.
                                    location.href = "#notas";
                                }
                            }
                        }
                    });
                } else {
                    // Si el backend (php) respondió un error, lo mostramos.
                    $.alert({
                        title: 'Error',
                        content: rta.msg
                    });
                } 
            }
        });
    });
    
    // Eliminar con event delegation...
    // Le agregamos al botón de eliminar la funcionalidad.
    listaNotas.on('click', '.nota-eliminar', function() {
        // Para borrar el elemento tenemos que buscar primero
        // el elemento que quiero eliminar.
        // Extendemos el botón, y buscamos a su padre (el
        // article.nota).
        var button = $(this);
        var articleABorrar = button.parent();

        // Le agregamos una confirmación previa:
        $.confirm({
            title: 'SEGURO?',
            content: 'Estás a punto de eliminar DEFINITIVAMENTE la nota. Seguimos?',
            type: 'red',
            escapeKey: 'cancelar',
            buttons: {
                cancelar: function(){},
                eliminar: {
                    btnClass: 'btn-red',
                    action: function() {
                        // Hacemos la petición de ajax para eliminar.
                        $.ajax({
                            // Cuando suban los php a un hosting...
                    //        url: 'http://www.sitio.com/api/eliminar-nota.php',
                            // Pero localmente, apuntamos a alguna carpeta.
                            url: 'http://localhost/santiago/api/eliminar-nota.php',
                            type: 'POST',
                            data: `id=${button.attr('data-id')}`,
                            success: function(rta) {
                                if(rta.success) {
                                    // Borramos el article :)
                                    articleABorrar.remove();
                                } else {
                                    $.alert({
                                        title: 'Error',
                                        content: rta.msg
                                    });
                                }
                            }
                        });
                    }
                }
            }
        });
    });
    
    // Función para recrear la lista de notas, para ayudarnos
    // con los datos leídos de localStorage.
    function recrearListaNotas(notas) {
        // Armamos una variable para ir acumulando los
        // items que creemos desde el array de notas.
        var salida = '';
        
        // Recorremos las notas.
        for(var i = 0; i < notas.length; i++) {
            // Agregamos a salida la nota...
            // Noten que le agregamos al button de eliminar
            // el data-i con el valor del i de la nota.
            salida += `<article class="nota">
                <h3 class="nota-titulo">${notas[i].nombre_instancia} - ${notas[i].nombre_carrera} - ${notas[i].nombre_materia}</h3>
                <p class="nota-fecha">Fecha: ${notas[i].fecha}</p>
                <p class="nota-nota">Nota: ${notas[i].nota}</p>
                <p class="nota-comentarios">Comentarios: ${notas[i].comentarios}</p>
                <button class="nota-eliminar ui-btn ui-shadow ui-corner-all" data-id="${notas[i].id_nota}">Eliminar</button>
            </article>`;
        }
        
        // Agregamos la salida que generamos a la lista.
        listaNotas.html(salida);
    }
    
    function cargarCarreras() {
        $.ajax({
            url: 'http://localhost/santiago/api/traer-carreras.php',
            type: 'GET',
            success: function(rta) {
                // Generamos los options para cada carrera.
                var salida = '';
                
                for(var i = 0; i < rta.length; i++) {
                    salida += `<option value="${rta[i].id_carrera}">${rta[i].nombre}</option>`
                }
                
                // Agregamos los options al select.
                inputCarrera.html(salida);
            }
        });
    }
    
    function cargarMaterias() {
        $.ajax({
            url: 'http://localhost/santiago/api/traer-materias.php',
            type: 'GET',
            success: function(rta) {
                // Generamos los options para cada carrera.
                var salida = '';
                
                for(var i = 0; i < rta.length; i++) {
                    salida += `<option value="${rta[i].id_materia}">${rta[i].nombre}</option>`
                }
                
                // Agregamos los options al select.
                inputMateria.html(salida);
            }
        });
    }
});









