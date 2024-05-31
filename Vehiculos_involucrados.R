library(dplyr)
library(ggplot2)
library(lubridate)
library(hms)

ruta<-"C:/Users/JuanPabloOrdoñez/Documents/VisDatos/nuevo_acumulado_ht_vehiculos_incolucrados_2023_12 (1).csv"
datos<-read.csv(ruta)

datos <- datos %>%
  mutate(fecha_evento = as.Date(fecha_evento, format="%Y-%m-%d"),
         hora_evento = as_hms(hora_evento))

tipo_evento_count <- datos %>%
  count(tipo_evento) %>%
  arrange(desc(n))

ggplot(tipo_evento_count, aes(x=reorder(tipo_evento, n), y=n)) +
  geom_bar(stat="identity") +
  coord_flip() +
  labs(title="Cantidad de incidentes por tipo de evento",
       x="Tipo de evento",
       y="Cantidad")

datos <- datos %>%
  mutate(dia_semana = wday(fecha_evento, label=TRUE, abbr=FALSE))

incidentes_dia <- datos %>%
  count(dia_semana) %>%
  arrange(desc(n))

ggplot(incidentes_dia, aes(x=reorder(dia_semana, n), y=n)) +
  geom_bar(stat="identity") +
  labs(title="Cantidad de incidentes por día de la semana",
       x="Día de la semana",
       y="Cantidad")

alcaldia_count <- datos %>%
  count(alcaldia) %>%
  arrange(desc(n))

ggplot(alcaldia_count, aes(x=reorder(alcaldia, n), y=n)) +
  geom_bar(stat="identity") +
  coord_flip() +
  labs(title="Cantidad de incidentes por alcaldía",
       x="Alcaldía",
       y="Cantidad")

datos <- datos %>%
  mutate(latitud = as.numeric(latitud),
         longitud = as.numeric(longitud))

prioridad_count <- datos %>% count(prioridad)


ggplot(prioridad_count, aes(x = prioridad, y = n, fill = prioridad)) +
  geom_bar(stat = "identity") +
  labs(title = "Distribución de Accidentes por Prioridad",
       x = "Prioridad",
       y = "Número de Accidentes") +
  theme_minimal()

interseccion_count <- datos %>% count(tipo_de_interseccion)

ggplot(interseccion_count, aes(x = reorder(tipo_de_interseccion, n), y = n, fill = tipo_de_interseccion)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Distribución de Accidentes por Tipo de Intersección",
       x = "Tipo de Intersección",
       y = "Número de Accidentes") +
  theme_minimal()

vehiculo_count <- datos %>% count(tipo_vehiculo)


ggplot(vehiculo_count, aes(x = reorder(tipo_vehiculo, n), y = n, fill = tipo_vehiculo)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Distribución de Accidentes por Tipo de Vehículo",
       x = "Tipo de Vehículo",
       y = "Número de Accidentes") +
  theme_minimal()

#Cruzamos prioridad con intersección
prioridad_interseccion_count <- datos %>% count(prioridad, tipo_de_interseccion)


ggplot(prioridad_interseccion_count, aes(x = tipo_de_interseccion, y = n, fill = prioridad)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  labs(title = "Distribución de Accidentes por Prioridad y Tipo de Intersección",
       x = "Tipo de Intersección",
       y = "Número de Accidentes") +
  theme_minimal()

#Prioridad con vehículo
prioridad_vehiculo_count <- datos %>% count(prioridad, tipo_vehiculo)

ggplot(prioridad_vehiculo_count, aes(x = tipo_vehiculo, y = n, fill = prioridad)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  labs(title = "Distribución de Accidentes por Prioridad y Tipo de Vehículo",
       x = "Tipo de Vehículo",
       y = "Número de Accidentes") +
  theme_minimal()

#Intersección con vehículo
interseccion_vehiculo_count <- datos %>% count(tipo_de_interseccion, tipo_vehiculo)

ggplot(interseccion_vehiculo_count, aes(x = tipo_de_interseccion, y = n, fill = tipo_vehiculo)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  labs(title = "Distribución de Accidentes por Tipo de Intersección y Tipo de Vehículo",
       x = "Tipo de Intersección",
       y = "Número de Accidentes") +
  theme_minimal()

#Prioridad y alcaldía
prioridad_alcaldia_count <- datos %>% count(prioridad, alcaldia)
ggplot(prioridad_alcaldia_count, aes(x = alcaldia, y = n, fill = prioridad)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  labs(title = "Distribución de Accidentes por Prioridad y Alcaldía",
       x = "Alcaldía",
       y = "Número de Accidentes") +
  theme_minimal()

#Hora y prioridad
datos <- datos %>%
  mutate(hora_evento = hms::as_hms(hora_evento))
hora_prioridad_count <- datos %>% 
  mutate(hora = hour(hora_evento)) %>% 
  count(hora, prioridad)
ggplot(hora_prioridad_count, aes(x = hora, y = n, color = prioridad)) +
  geom_line() +
  labs(title = "Distribución de Accidentes por Hora del Día y Prioridad",
       x = "Hora del Día",
       y = "Número de Accidentes") +
  theme_minimal()

#Día de la semana y vehículo
dia_vehiculo_count <- datos %>% count(dia_semana, tipo_vehiculo)
ggplot(dia_vehiculo_count, aes(x = dia_semana, y = n, fill = tipo_vehiculo)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Distribución de Accidentes por Día de la Semana y Tipo de Vehículo",
       x = "Día de la Semana",
       y = "Número de Accidentes") +
  theme_minimal()

#Vialidad con intersección
vialidad_interseccion_count <- datos %>% count(clasificacion_de_la_vialidad, tipo_de_interseccion)
ggplot(vialidad_interseccion_count, aes(x = clasificacion_de_la_vialidad, y = n, fill = tipo_de_interseccion)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  labs(title = "Distribución de Accidentes por Clasificación de la Vialidad y Tipo de Intersección",
       x = "Clasificación de la Vialidad",
       y = "Número de Accidentes") +
  theme_minimal()

#Intersección e intersección semaforizada
interseccion_semaforo_count <- datos %>% count(tipo_de_interseccion, interseccion_semaforizada)

ggplot(interseccion_semaforo_count, aes(x = tipo_de_interseccion, y = n, fill = interseccion_semaforizada)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  labs(title = "Distribución de Accidentes por Tipo de Intersección y Intersección Semaforizada",
       x = "Tipo de Intersección",
       y = "Número de Accidentes") +
  theme_minimal()

#Prioridad y semáforo
prioridad_semaforo_count <- datos %>% count(prioridad, interseccion_semaforizada)

ggplot(prioridad_semaforo_count, aes(x = interseccion_semaforizada, y = n, fill = prioridad)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Distribución de Accidentes por Prioridad y Intersección Semaforizada",
       x = "Intersección Semaforizada",
       y = "Número de Accidentes") +
  theme_minimal()