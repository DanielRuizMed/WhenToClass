## Herramienta de pruebas para Ruby: minitest :small_orange_diamond:
Para la realización de este proyecto se utiliza como herramienta para realizar las pruebas del código la herramienta minitest. Esta herramienta es la evolución de unit/test que incluye más funcionalidades como por ejemplo Mocks. Es una herramienta escrita en Ruby para probar código escrito en este mismo lenguaje. Permite realizar lo que se conoce como pruebas unitarias, es decir, probar clases y métodos al igual que RSPEC. Además minitest continúa evolucionando gracias a los aportes de la comunidad y el trabajo de cientos de colaboradores. Se puede consultar el repositorio oficial [aquí](https://github.com/seattlerb/minitest).
### ¿Por qué minitest?
Se ha elegido debido a que es una herramienta muy sencilla con una sintaxis también muy sencilla ya que todo se escribe como si fuese una clase de Ruby con sus métodos, donde cada método es un test. En cuanto a la documentación a diferencia de RSPEC, he sido capaz de encontrar una mayor cantidad de [documentación](http://docs.seattlerb.org/minitest/Minitest/Assertions.html) y la curva de aprendizaje ha sido mucho menor al tener una sintaxis muy intuitiva y limpia ya que es simplemente Ruby. Además no genera ficheros a diferencia de RSPEC que genera una carpeta y además un fichero dentro de esa carpeta con código que cuesta encontrar para lo que sirve en la documentación oficial, minitest no nos genera en nuestro directorio ningún fichero, sólo debemos empezar a escribir tests.
Además, minitest es mucho más rápido ejecutando tests e incluye el uso de fixtures sin tener que instalar nada más.

### Como instalar minitest
La instalación de minitest es muy sencilla y puede ser consultada [aquí](https://github.com/seattlerb/minitest).

En el Gemfile se añade "gem 'minitest'" y se ejecuta bundle install.
