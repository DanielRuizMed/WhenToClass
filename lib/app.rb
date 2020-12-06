require "roda"
require "json"
require_relative "../lib/FSDator.rb"
require_relative "../lib/gestorgrados.rb"
require_relative "../lib/parse.rb"

class App < Roda
    ####################
    #Plugins
    plugin :all_verbs #por defecto solo trae GET y POST, queremos más.
    plugin :response_request #nos permite personalizar más las respuestas

    
    ####################
    #Rutas
    route do |r|
        @dator = FSDator.new("data")
        @gestor = GestorGrados.new(@dator)
        @parse = Parse.new
        #Directorio Raíz
        r.root do
            response.status = 200
            response['Content-Type'] = 'application/json'
            body = 
                {
                    "status"=>200
                }
            response.write(body.to_json)
        end

        # /grados
        r.on "grados" do
            # GET /grados
            r.get do
                #obtenemos todos los grados
                grados = Array.new
                grados = @gestor.todosGrados()
                gradosjson = Array.new
                #los pasamos a JSON
                for i in 0..grados.length()-1
                    gradosjson.push(@parse.gradoToJSON(grados[i]))
                end

                #preparamos la respuesta
                response.status = 200
                response['Content-Type'] = 'application/json'
                response.write(gradosjson.to_json)
            end
        end

        # /grado
        r.on "grado" do
            # /grado/$ID
            r.on /[a-f0-9]{20}/ do |id|
                
                # Rama /grado/$ID/asignatura/$ID2
                r.on "asignatura" do
                    r.on /[a-f0-9]{20}/ do |id|
                        # /asignatura/$ID/horario
                        r.get "horario" do
                            "obtener el horario de la asignatura"
                        end

                        # /asignatura/$ID/enlaces
                        r.get "enlaces" do
                            "obtener los enlaces de la asignatura"
                        end

                        # /asignatura/$ID/turnos
                        r.get "turnos" do
                            "obtener los turnos de la asignatura"
                        end
                            
                        # /asignatura/$ID
                        r.get do
                            "obtiene toda la información de una asignatura"    
                        end

                        r.delete do
                            "elimina la asignatura"
                        end
                    end
                    r.post do
                        "añadir una asignatura"
                    end
                end

                # /grado/$ID/asignaturas
                r.on "asignaturas" do
                    r.get do
                        "obtener las asignaturas del grado"
                    end
                end
                # get /grado/$ID
                r.get do
                    "obtener información del grado"
                end

                # delelete /grado/$ID
                r.delete do
                    "eliminar el grado"
                end

                # post /grado/$ID
                r.post do
                    "añadir grado"
                end
            end
        end
    end
end