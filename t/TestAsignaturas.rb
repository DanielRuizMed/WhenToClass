require "minitest/autorun"
require "minitest/mock"
require "date"
require_relative "../lib/asignatura.rb"
require_relative "../lib/horarioasignatura.rb"

class TestAsignaturas < Minitest::Test
	#####################################################################################
	#Definimos en primer lugar un objeto de la clase con el cual vamos a 
	#trabajar en los tests
	#####################################################################################
	def setup
		@asignatura = Asignatura.new("Infraestructura Virtual", 
						HorarioAsignatura.new("2-Martes", "11:30", "13:30", "T"), 
						[HorarioAsignatura.new("2-Martes", "9:30", "11:30", "P1"), 
						HorarioAsignatura.new("5-Viernes", "9:30", "11:30", "P2")],
						"A",
						[["28sep - 2oct", "12oct - 16oct", "26oct - 30oct", "9nov - 13nov", "23nov - 27nov", "7dec - 11dec", "21dec - 22dec"],
						["5oct - 9oct", "19oct - 23oct", "2nov - 6nov","16nov - 20nov", "30nov - 4dec", "14dec - 18dec", "8jan y 11jan - 14jan"]],
						)
		@asignaturaSinHorarioTeoria = Asignatura.new("Infraestructura Virtual", 
						nil, 
						[HorarioAsignatura.new("2-Martes", "9:30", "11:30", "P1"), 
						HorarioAsignatura.new("5-Viernes", "9:30", "11:30", "P2")],
						"A",
						[["28sep - 2oct", "12oct - 16oct", "26oct - 30oct", "9nov - 13nov", "23nov - 27nov", "7dec - 11dec", "21dec - 22dec"],
						["5oct - 9oct", "19oct - 23oct", "2nov - 6nov","16nov - 20nov", "30nov - 4dec", "14dec - 18dec", "8jan y 11jan - 14jan"]],
						)
		@asignaturaSinHorarioPracticas = Asignatura.new("Infraestructura Virtual", 
						HorarioAsignatura.new("2-Martes", "11:30", "13:30", "T"), 
						nil,
						"A",
						[["28sep - 2oct", "12oct - 16oct", "26oct - 30oct", "9nov - 13nov", "23nov - 27nov", "7dec - 11dec", "21dec - 22dec"],
						["5oct - 9oct", "19oct - 23oct", "2nov - 6nov","16nov - 20nov", "30nov - 4dec", "14dec - 18dec", "8jan y 11jan - 14jan"]],
						)
		@asignaturaSinHorario = Asignatura.new("Infraestructura Virtual", 
						nil, 
						nil,
						"A",
						[["28sep - 2oct", "12oct - 16oct", "26oct - 30oct", "9nov - 13nov", "23nov - 27nov", "7dec - 11dec", "21dec - 22dec"],
						["5oct - 9oct", "19oct - 23oct", "2nov - 6nov","16nov - 20nov", "30nov - 4dec", "14dec - 18dec", "8jan y 11jan - 14jan"]],
						)
	end
	
	#####################################################################################
	#Con los siguientes tests vamos a comprobar si funciona correctamente el método
	#que nos permite obtener tanto el horario de prácticas como el de teoría
	#ordenado por el día de la semana
	#
	#Método: obtenerHorario
	#
	#####################################################################################
	
	#TEST 1 obtenerHorario
	#Si el horario de teoría o prácticas o ambos están vacíos debería dar error
	#todas las asignaturas tienen tanto prácticas como teoría
	def test_that_obtenerHorario_method_return_error_if_horario_vacio
		assert_equal "Error: Horario de teoría o prácticas vacío.", @asignaturaSinHorarioTeoria.obtenerHorario("P1"), "Fallo al saltar error debido a horario vacio"
		assert_equal "Error: Horario de teoría o prácticas vacío.", @asignaturaSinHorarioPracticas.obtenerHorario("P1"), "Fallo al saltar error debido a horario vacio"
		assert_equal "Error: Horario de teoría o prácticas vacío.", @asignaturaSinHorario.obtenerHorario("P1"), "Fallo al saltar error debido a horario vacio"
	end

	#TEST 2 obtenerHorario
	#Si el grupo de prácticas proporcionado como argumento no existe debería dar un error
	def test_that_grupopracticas_existe_en_obtenerHorario_method
		assert_equal "Error: Solo hay 2 grupos de prácticas", @asignatura.obtenerHorario("P12"), "Fallo al saltar error debido a grupo proporcionado no válido"
	end
	
	#TEST 3 obtenerHorario
	#Si tanto el grupo proporcionado como el objeto asignatura es correcto para llamar a este 
	#método:
	# -Deberíamos obtener un vector de tamaño >= 2 (horario de practicas y de teoria)
	# -Deberíamos obtener un vector donde cada posición es un Struct horarioasignatura
	# -Deberíamos obtener un vector ordenado de las clases que tocan de esa asignatura
	#  ordenado de lunes a viernes
	def test_that_obtenerHorario_method_return_valores_correctos_si_no_hay_errores
		horario_asignatura = @asignatura.obtenerHorario("P1")
		#Se comprueba que al menos hay horario de teoría y horario de prácticas
		assert_operator horario_asignatura.length(), :>=, 2, "Fallo al obtener los horarios de prácticas y teoría"
		#Para cada elemento del vector, se comprueba que es una instacia de HorarioAsignatura (nuestra estructura)
		for i in 0..horario_asignatura.length() - 1 do
			assert_instance_of HorarioAsignatura, horario_asignatura[i]
		end
		
		#Ahora comprobamos que lo devuelve en orden (Lunes, Martes, ...)
		for i in 0..horario_asignatura.length() - 1 do
			if(i != horario_asignatura.length() - 1)
				assert_operator horario_asignatura[i].dia[0].to_i, :<=, horario_asignatura[i+1].dia[0].to_i
			end
		end
	end
	
	#####################################################################################
	#Con los siguientes tests vamos a comprobar si funciona correctamente el método
	#que nos permite dado un turno (1, 2, ...) y un mes devolver el conjunto
	#de días que hay que ir
	#
	#Método: obtenerDiasPresenciales
	#
	#####################################################################################
	
	#TEST 1 obtenerDiasPresenciales
	#Se comprueba que si el turno proporcionado no existe da error
	def test_that_obtenerDiasPresenciales_method_return_error_si_grupo_no_existe
		assert_equal "Error: El turno debe ser numérico y menor que 2.", @asignatura.obtenerDiasPresenciales("12", "oct"), "Fallo al saltar error debido a grupo no valido"
	end
	
	#TEST 2 obtenerDiasPresenciales
	#Se comprueba que si el mes proporcionado no es válido da error
	def test_that_obtenerDiasPresenciales_method_return_error_si_mes_no_valido
		assert_equal "Error: El mes no es válido.", @asignatura.obtenerDiasPresenciales("1", "mayo"), "Fallo al saltar error debido a mes no valido"
	end
	
	#TEST 3
	#Si se le pasan bien los datos se tiene que comprobar que:
	# -Se obtiene un vector de longitud al menos > 1
	# -En cada componente del vector devuelto existe la palabra pasada como mes
	def test_that_obtenerDiasPresenciales_method_return_valores_correctos
		#obtenemos los días que hay que ir en octubre
		dias_presenciales = @asignatura.obtenerDiasPresenciales("1", "oct")
		
		#Se comprueba que para el mes de octubre el grupo 1 tiene más de una semana a la
		#que asistir
		assert_operator dias_presenciales.length(), :>=, 1, "Fallo al obtener los días presenciales"
		
		#Se comprueba que cada componente del vector contiene el mes dado como palabra
		for i in 0..dias_presenciales.length() - 1 do
			assert_match /.*oct*./,  dias_presenciales[i]
		end
	end
	
	#####################################################################################
	#Con los siguientes tests vamos a comprobar si funciona correctamente el método
	#que nos permite saber si debemos ir esta semana a una asignatura
	#
	#Método: tengoQueIrEstaSemana
	#
	#####################################################################################
	
	#TEST 1
	#Se comprueba que si el turno proporcionado no existe da error
	def test_that_tengoQueIrEstaSemana_method_return_error_si_grupo_no_existe
		assert_equal "Error: El turno debe ser numérico y menor que 2.", @asignatura.tengoQueIrEstaSemana("13"), "Fallo al saltar error debido a turno no valido"
	end
	
	#TEST 2
	#Se comprueba que el metodo devuelve true o false en función de si hay que ir esta semana
	def test_that_tengoQueIrEstaSemana_method_return_valores_correctos
		#necesario ya que dependía del día actual puede cambiar el resultado
		DateTime.stub(:now, Date.new(2020,10,13)) do
			assert_equal true, @asignatura.tengoQueIrEstaSemana("1")
		end
	end
end
