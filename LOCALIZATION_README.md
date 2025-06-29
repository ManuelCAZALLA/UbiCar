# Localización de UbiCar

Este documento explica cómo funciona la localización en la aplicación UbiCar y cómo añadir nuevos idiomas o textos.

## Estructura de Archivos

La localización está organizada en las siguientes carpetas:

```
UbiCar/Resources/
├── es.lproj/          # Español (idioma base)
├── en.lproj/          # Inglés
├── fr.lproj/          # Francés
├── de.lproj/          # Alemán
└── String+Localization.swift  # Extensión para facilitar el uso
```

## Archivos de Localización

### Localizable.strings
Contiene todas las cadenas de texto de la aplicación organizadas por secciones:

- **App General**: Nombres de la aplicación y textos generales
- **Location**: Textos relacionados con ubicación y permisos
- **Parking**: Textos relacionados con el aparcamiento
- **Voice Guide**: Mensajes de voz
- **Buttons**: Textos de botones
- **Coordinates**: Formato de coordenadas

### InfoPlist.strings
Contiene las descripciones de permisos del sistema que se muestran al usuario.

## Cómo Usar la Localización

### 1. Texto Simple
```swift
Text("welcome_to_ubicar".localized)
```

### 2. Texto con Formato
```swift
Text("car_distance_message".localized(with: Int(distance)))
```

### 3. Texto con Múltiples Argumentos
```swift
Text("coordinates_format".localized(with: latitude, longitude))
```

## Añadir Nuevos Idiomas

1. Crear una nueva carpeta `[código_idioma].lproj` (ej: `it.lproj` para italiano)
2. Copiar los archivos `Localizable.strings` e `InfoPlist.strings` de `es.lproj`
3. Traducir todas las cadenas al nuevo idioma
4. Añadir el idioma en Xcode: Project Settings > Info > Localizations

## Añadir Nuevos Textos

1. Añadir la nueva clave en todos los archivos `Localizable.strings`
2. Usar la clave en el código con `.localized`

### Ejemplo:
```swift
// En Localizable.strings
"new_feature_title" = "Nueva función";

// En el código
Text("new_feature_title".localized)
```

## Códigos de Idioma Soportados

- `es`: Español (idioma base)
- `en`: Inglés
- `fr`: Francés
- `de`: Alemán

## Notas Importantes

- Siempre usar claves descriptivas y organizadas por secciones
- Mantener consistencia en el formato de las cadenas con parámetros
- Probar la aplicación en todos los idiomas antes de publicar
- Usar la extensión `String+Localization.swift` para facilitar el uso

## Herramientas Útiles

- **Xcode**: Editor integrado para archivos .strings
- **AppleGlot**: Herramienta de Apple para gestionar localizaciones
- **Lokalise**: Herramienta de terceros para gestión de traducciones 