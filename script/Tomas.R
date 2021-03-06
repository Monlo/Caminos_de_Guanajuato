rm(list=ls())
setwd("~")

# Cargar Paquetes 
require(readxl)
require(tidyverse)
require(stringr)
require(mxmaps)
require(dplyr)
require(plyr)
require(ggplot2)
require(pacman)
require(rgdal)
require(ggrepel)

#################################
##   CAMINOS DE GUANAJUATO     ##
## PT. 2. TOMAS CLANDESTINAS   ##
#################################

# 1. �Como han aumentado las tomas clandestinas en el estado? 
#    Fuente de datos: Serendepia Digital (Tomas a nivel municipal) 
#    Periodo: 200- 2018

inp = "C://Users//lopez//OneDrive//Documentos//Art�culos//Caminos de Guanajuato//Mapas//Tomas" 
out = "C://Users//lopez//OneDrive//Documentos//Art�culos//Caminos de Guanajuato//output"

# Leo la base de tomas
base = read_xlsx(paste(inp, "Tomas-clandestinas-M�xico-2000-2018.xlsx", sep="//")) # mismo paquete que para read_excel

# Leo la base de cat�logos municipales de INEGI
# Abro la base de datos con los cat�logos por municipio del INEGI
# Consultar en la siguiente liga:
# https://www.inegi.org.mx/app/ageeml/

# Quiero las claves por municipio y peg�rselas a los municipios de tomas
inp2 = "C://Users//lopez//OneDrive//Documentos//Art�culos//Caminos de Guanajuato//input" 
muni<- read.csv(paste(inp2, "catun_localidad.csv", sep="/"), as.is=T, stringsAsFactors = F, sep=",")

# selecciono las variables que me interesan
claves<- select(muni, Cve_Ent, Nom_Ent, Cve_Mun, Nom_Mun) 

names(claves)<- c("cve_ent", "ent", "cve_mun", "mun")

# Filtro para guanajuato
gto_tomas <- filter(base, estado=="Guanajuato")
gto_claves<- filter(claves, cve_ent=="11")

# Elimino duplicados
gto_claves <- gto_claves[!duplicated(gto_claves), ]

# Emparejo los nombres
# Silao
gto_tomas$municipio = gsub("Silao de la Victoria", "Silao", gto_tomas$municipio)      
gto_tomas$municipio = gsub("Mipo. De Silao, Gto.", "Silao", gto_tomas$municipio)      
gto_tomas$municipio = gsub("SILAO", "Silao", gto_tomas$municipio)      
gto_tomas$municipio = gsub("Silao, Gto.", "Silao", gto_tomas$municipio)      
gto_claves$mun=gsub("Silao De La Victoria", "Silao", gto_claves$mun)

# Apaseo El Alto
gto_tomas$municipio = gsub("Apaseo el Alto", "Apaseo El Alto", gto_tomas$municipio) 
gto_tomas$municipio = gsub("Apaseo El Alto, Gto.", "Apaseo El Alto", gto_tomas$municipio) 
gto_tomas$municipio = gsub("APASEO EL ALTO", "Apaseo El Alto", gto_tomas$municipio) 
gto_tomas$municipio = gsub("Apaseo el Alto, Gto.", "Apaseo El Alto", gto_tomas$municipio) 
gto_tomas$municipio = gsub("Apaseo El Alto. Gto.", "Apaseo El Alto", gto_tomas$municipio) 

# San Luis de la Paz
gto_tomas$municipio = gsub("San Luis De La Paz", "San Luis De La Paz", gto_tomas$municipio) 
gto_tomas$municipio = gsub("San Luis De La Paz, Gto.", "San Luis De La Paz", gto_tomas$municipio) 

# San Diego de la Uni�n
gto_tomas$municipio = gsub("San Diego De La Uni�n", "San Diego De La Uni�n", gto_tomas$municipio) 
gto_tomas$municipio = gsub("San Diego De La Union, Gto.", "San Diego De La Uni�n", gto_tomas$municipio) 
gto_tomas$municipio = gsub("San Diego De La Union Gto.", "San Diego De La Uni�n", gto_tomas$municipio) 
gto_tomas$municipio = gsub("San Diego De La Uni�n, Gto.", "San Diego De La Uni�n", gto_tomas$municipio) 

gto_tomas$municipio = gsub("San Diego De La Union, Gto.", "San Diego De La Uni�n", gto_tomas$municipio) 
gto_tomas$municipio = gsub("San Diego De La Uni�n, Gto.", "San Diego De La Uni�n", gto_tomas$municipio) 
gto_tomas$municipio = gsub("San Diego De La Union, Gto.", "San Diego De La Uni�n", gto_tomas$municipio) 
gto_tomas$municipio = gsub("San Diego De La Union, Gto.", "San Diego De La Uni�n", gto_tomas$municipio) 
gto_tomas$municipio = gsub("San Diego de la Uni�n, Gto.", "San Diego De La Uni�n", gto_tomas$municipio) 

gto_tomas$municipio = gsub("San Diego de la Uni�n", "San Diego De La Uni�n", gto_tomas$municipio) 

# Valle de Santiago
gto_tomas$municipio = gsub("Valle De Santiago", "Valle De Santiago", gto_tomas$municipio) 
gto_tomas$municipio = gsub("Valle De Santiago, Gto.", "Valle De Santiago", gto_tomas$municipio) 
gto_tomas$municipio = gsub("San Vicente De Garma, Gto.", "Valle De Santiago", gto_tomas$municipio) 
gto_tomas$municipio = gsub("VALLE DE SANTIAGO", "Valle De Santiago", gto_tomas$municipio) 

# Apaseo el Grande
gto_tomas$municipio = gsub("Apaseo El Grande, Gto.", "Apaseo El Grande", gto_tomas$municipio) 
gto_tomas$municipio = gsub("Apaseo El Grande", "Apaseo El Grande", gto_tomas$municipio) 
gto_tomas$municipio = gsub("APASEO EL GRANDE", "Apaseo El Grande", gto_tomas$municipio) 

# Doctor Mora
gto_tomas$municipio = gsub("Dr. Mora", "Doctor Mora", gto_tomas$municipio) 

# Morole�n
gto_tomas$municipio = gsub("Morole�n, Gto.", "Morole�n", gto_tomas$municipio) 
gto_tomas$municipio = gsub("Moroleon", "Morole�n", gto_tomas$municipio) 
gto_tomas$municipio = gsub("MOROLe�n", "Morole�n", gto_tomas$municipio) 
gto_tomas$municipio = gsub("MOROLe�n", "Morole�n", gto_tomas$municipio) 
gto_tomas$municipio = gsub("MOROLe�n", "Morole�n", gto_tomas$municipio) 

# Villagr�n
gto_tomas$municipio = gsub("Nopala De Villagr�n", "Villagr�n", gto_tomas$municipio) 
gto_tomas$municipio = gsub("Villagran", "Villagr�n", gto_tomas$municipio) 
gto_tomas$municipio = gsub("VILLAGRAN", "Villagr�n", gto_tomas$municipio) 

# Valle de Santiago
gto_tomas$municipio = gsub("Atotonilco El Alto, Gto.", "San Miguel De Allende", gto_tomas$municipio) 

# Irapuato
gto_tomas$municipio = gsub("Irapuato, Gto.", "Irapuato", gto_tomas$municipio) 
gto_tomas$municipio = gsub("IRAPUATO", "Irapuato", gto_tomas$municipio) 

# Le�n
gto_tomas$municipio = gsub("Le�n, Gto.", "Le�n", gto_tomas$municipio) 
gto_tomas$municipio = gsub("Le�n, Gto.", "Le�n", gto_tomas$municipio) 
gto_tomas$municipio = gsub("LEON", "Le�n", gto_tomas$municipio) 
gto_tomas$municipio = gsub("Leon", "Le�n", gto_tomas$municipio) 
gto_tomas$municipio = gsub("Le�n Gto.", "Le�n", gto_tomas$municipio) 
gto_tomas$municipio = gsub("Le�n, Gto.", "Le�n", gto_tomas$municipio) 

# San Jos� Iturbide
gto_tomas$municipio = gsub("San Jos� Iturbide, Gto.", "San Jos� Iturbide", gto_tomas$municipio) 
gto_tomas$municipio = gsub("San Jos� De Iturbide, Gto.", "San Jos� Iturbide", gto_tomas$municipio) 

# San Diego de la Uni�n
gto_tomas$municipio = gsub("San Diego de la Uni�n, Gto.", "San Diego de la Uni�n", gto_tomas$municipio) 
gto_tomas$municipio = gsub("San Diego De La Union", "San Diego De La Uni�n", gto_tomas$municipio) 
gto_tomas$municipio = gsub("San Diego De La Union", "San Diego De La Uni�n", gto_tomas$municipio) 
gto_tomas$municipio = gsub("San Diego de la Uni�n", "San Diego De La Uni�n", gto_tomas$municipio) 

# P�njamo
gto_tomas$municipio = gsub("P�njamo, Gto.", "P�njamo", gto_tomas$municipio) 
gto_tomas$municipio = gsub("Penjamo", "P�njamo", gto_tomas$municipio) 
gto_tomas$municipio = gsub("PENJAMO", "P�njamo", gto_tomas$municipio) 
gto_tomas$municipio = gsub("P�njamo Gto.", "P�njamo", gto_tomas$municipio) 
gto_tomas$municipio = gsub("Santa Ana Pacueco", "P�njamo", gto_tomas$municipio) 
gto_tomas$municipio = gsub("P�njamo, Gto.", "P�njamo", gto_tomas$municipio) 

# Pueblo Nuevo
gto_tomas$municipio = gsub("Pueblo Nuevo, Gto.", "Pueblo Nuevo", gto_tomas$municipio) 
gto_tomas$municipio = gsub("PUEBLO NUEVO", "Pueblo Nuevo", gto_tomas$municipio) 

# Celaya
gto_tomas$municipio = gsub("Celaya, Gto.", "Celaya", gto_tomas$municipio) 
gto_tomas$municipio = gsub("Celaya, Gto.", "CELAYA", gto_tomas$municipio) 
gto_tomas$municipio = gsub("CELAYA", "Celaya", gto_tomas$municipio) 

# Abasolo
gto_tomas$municipio = gsub("Abasolo, Gto.", "Abasolo", gto_tomas$municipio) 
gto_tomas$municipio = gsub("ABASOLO", "Abasolo", gto_tomas$municipio) 

# Villagr�n
gto_tomas$municipio = gsub("Villagr�n, Gto.", "Villagr�n", gto_tomas$municipio) 

# Cortazar
gto_tomas$municipio = gsub("Cortazar, Gto.", "Cortazar", gto_tomas$municipio) 
gto_tomas$municipio = gsub("Cortazar Gto.", "Cortazar", gto_tomas$municipio) 
gto_tomas$municipio = gsub("CORTAZAR", "Cortazar", gto_tomas$municipio) 

# Cuer�maro
gto_tomas$municipio = gsub("CUERAMARO", "Cuer�maro", gto_tomas$municipio) 

# Guanajuato
gto_tomas$municipio = gsub("Guanajuato, Gto.", "Guanajuato", gto_tomas$municipio) 
gto_tomas$municipio = gsub("GUANAJUATO", "Guanajuato", gto_tomas$municipio) 

# Salamanca
gto_tomas$municipio = gsub("Salamanca, Gto", "Salamanca", gto_tomas$municipio) 
gto_tomas$municipio = gsub("Salamanca.", "Salamanca", gto_tomas$municipio) 
gto_tomas$municipio = gsub("SALAMANCA", "Salamanca", gto_tomas$municipio) 

# Uriangato
gto_tomas$municipio = gsub("Uriangato, Gto.", "Uriangato", gto_tomas$municipio) 
gto_tomas$municipio = gsub("URIANGATO", "Uriangato", gto_tomas$municipio) 

# Yuriria
gto_tomas$municipio = gsub("Yuriria, Gto.", "Yuriria", gto_tomas$municipio) 
gto_tomas$municipio = gsub("Yuriria, Gto", "Yuriria", gto_tomas$municipio) 
gto_tomas$municipio = gsub("YURIRIA", "Yuriria", gto_tomas$municipio) 

# Hay una observaci�n para Cuitzeo Del Porvenir, pero ese municipio est� en 
# Michoac�n, entonces voy a remover la observaci�n
gto_tomas<- filter(gto_tomas, municipio!="Cuitzeo Del Porvenir")

table(gto_tomas$municipio)
# Este municipio queda suelto
gto_tomas$municipio = gsub("MOROLe�n", "Morole�n", gto_tomas$municipio) 

#####################################################
# Juntar las claves de los municipios con las tomas #
#####################################################

# Pego a las tomas con las claves de los municipios
base_final<- left_join(gto_tomas, gto_claves, by=c("estado"="ent", "municipio"="mun"))

# Arreglamos el valor de la clave de municipio
base_final$cve_mun = as.numeric(base_final$cve_mun) %>%
           formatC(base_final$cve_mun, width = 3, format="d", flag="0")
base_final$region= paste0(base_final$cve_ent , base_final$cve_mun )

# Filtro y Selecciono las variables que quiero
base_final <- select(base_final, "year", "cve_ent", "estado", "cve_mun", "municipio", "tomas")

# Le cambio los nombres
names(base_final) <- c("year","cve_ent", "estado", "cve_mun", "municipio", "tomas")

# � Cu�ntas tomas se registraron cada a�o por municipio?
tomas_year = group_by(base_final, year, cve_ent, estado, cve_mun, municipio) %>%
             summarize(tot = sum(tomas, na.rm=T))

# �Y en el Estado?
tomas_year = group_by(base_final, year, estado) %>%
             summarize(tot = sum(tomas, na.rm=T)) 

# Filtro hasta 2018 para comparar anuales
tomas_year =filter(tomas_year, year!="2018")

ggplot(tomas_year,aes(x=year,y=tot)) +
  geom_line(color="#2b8cbe",size=1) +
  geom_point() +
  labs(title="Tomas clandestinas registradas por Pemex",
       subtitle="En el Estado de Guanajuato",
       caption="Fuente: Pemex",x="",y="Tomas clandestinas")+
  scale_x_continuous(breaks=seq(from=2000, to=2017, by=1))  +
  theme(axis.text.x = element_text(face="bold", size = 15, angle=90, hjust=1),
        title  = element_text(face="bold", size=14)) +
  theme_minimal() 
ggsave(paste(out, "tomas_gto.png", sep="/"), width=12, height=12) 


####################################################################
#######                   Mapear tomas                      ########
####################################################################

# Para la recreaci�n de este mapa, utilizamos el Paquete de Diego del Valle- Jones
# Para crear mapas de M�xico al nivel de estados y municipios
# Disponible en https://github.com/diegovalle/mxmaps

# Instalar el CRAN
#if (!require("devtools")) {
#  install.packages("devtools")
# }
# devtools::install_github("diegovalle/mxmaps")

# library("mxmaps", lib.loc="~/R/win-library/3.4")

# Graficar el cambio porcentual en la tasa de homicidios dolosos 2015-2018
# Cargamos la base de delitos a nivel municipal

# de 2012 a 2018, �Qu� municipios han acumulado m�s reportes por tomas clandestinas?
tomas_year<- filter(base_final, year== 2015 | year== 2016 | year== 2017 | year== 2018)

# Agrupamos
tomas_gto = group_by(tomas_year, cve_ent, estado, cve_mun, municipio)
tomas_gto = summarize(tomas_gto, tot = sum(tomas, na.rm=T))

# Arreglamos el valor de la clave de municipio
tomas <- as.data.frame(tomas_gto)
tomas$cve_mun = as.numeric(tomas$cve_mun)%>%
                formatC(width = 3, format="d", flag="0")
tomas$region  = paste0(tomas$cve_ent , tomas$cve_mun ) 

# Selecciono la regi�n y el total
tempo <- select(tomas, region, tot)
# Cambio los nombres
colnames(tempo)[2] <- "value"

#mapeamos
g<- mxmunicipio_choropleth(tempo, 
                           num_colors = 5,
                           zoom = c(11001:11046),
                           show_states = FALSE,
                           legend = "Tomas",
                           title = "Municipios con mayor n�mero de Tomas Clandestinas\nRegistradas por Pemex (2015-2018)") +
  scale_fill_brewer(palette="Blues") +
  labs(caption = "Fuente: PEMEX")
g
