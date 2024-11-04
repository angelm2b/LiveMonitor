# LiveMonitor

LiveMonitor es una aplicación SwiftUI diseñada para monitorear la disponibilidad de transmisiones de video en vivo.

## Características

- Agregar y gestionar enlaces de video en vivo
- Verificar el estado de las transmisiones en tiempo real
- Notificaciones cuando un video deja de estar disponible
- Interfaz de usuario intuitiva y fácil de usar

## Requisitos del sistema

- iOS 14.0 o posterior
- Xcode 12.0 o posterior
- Swift 5.3 o posterior

## Instalación

1. Clona este repositorio
2. Abre el proyecto en Xcode
3. Compila y ejecuta la aplicación en el simulador o en un dispositivo iOS

## Uso

1. **Agregar un nuevo enlace:**
   - Ingresa el nombre del enlace en el campo "Nombre del enlace"
   - Ingresa la URL del video en el campo "URL del video"
   - Presiona el botón "Agregar"

2. **Verificar el estado de un video:**
   - En la lista de enlaces, presiona el botón "Verificar" junto al enlace que deseas comprobar
   - La aplicación mostrará si el video está en vivo o no disponible

3. **Eliminar un enlace:**
   - Desliza el enlace hacia la izquierda o presiona el icono de papelera
   - Confirma la eliminación en el cuadro de diálogo

4. **Notificaciones:**
   - La aplicación solicitará permiso para enviar notificaciones
   - Recibirás una notificación cuando un video deje de estar disponible

## Estructura del proyecto

- `ContentView.swift`: Contiene la vista principal de la aplicación y la lógica de la interfaz de usuario
- `VideoLink.swift`: Define la estructura de datos para los enlaces de video
- `VideoLinkStore.swift`: Maneja el almacenamiento y la gestión de los enlaces de video
- `LiveMonitorApp.swift`: Punto de entrada de la aplicación
