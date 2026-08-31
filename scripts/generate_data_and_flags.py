#!/usr/bin/env python3
import os
import sqlite3
import urllib.request
import time

# Exact 195 sovereign countries (193 UN members + VA + PS)
# Continents: Americas, Europe, Asia, Africa, Oceania
# Difficulty: 1 (Fácil), 2 (Medio), 3 (Difícil)
COUNTRIES = [
    # Africa (54)
    {"iso_code": "AO", "name_es": "Angola", "capital_es": "Luanda", "continent": "Africa", "difficulty": 2},
    {"iso_code": "BF", "name_es": "Burkina Faso", "capital_es": "Uagadugú", "continent": "Africa", "difficulty": 3},
    {"iso_code": "BI", "name_es": "Burundi", "capital_es": "Gitega", "continent": "Africa", "difficulty": 3},
    {"iso_code": "BJ", "name_es": "Benín", "capital_es": "Porto Novo", "continent": "Africa", "difficulty": 3},
    {"iso_code": "BW", "name_es": "Botsuana", "capital_es": "Gaborone", "continent": "Africa", "difficulty": 3},
    {"iso_code": "CD", "name_es": "República Democrática del Congo", "capital_es": "Kinshasa", "continent": "Africa", "difficulty": 2},
    {"iso_code": "CF", "name_es": "República Centroafricana", "capital_es": "Bangui", "continent": "Africa", "difficulty": 3},
    {"iso_code": "CG", "name_es": "República del Congo", "capital_es": "Brazzaville", "continent": "Africa", "difficulty": 3},
    {"iso_code": "CI", "name_es": "Costa de Marfil", "capital_es": "Yamusukro", "continent": "Africa", "difficulty": 2},
    {"iso_code": "CM", "name_es": "Camerún", "capital_es": "Yaundé", "continent": "Africa", "difficulty": 2},
    {"iso_code": "CV", "name_es": "Cabo Verde", "capital_es": "Praia", "continent": "Africa", "difficulty": 3},
    {"iso_code": "DJ", "name_es": "Yibuti", "capital_es": "Yibuti", "continent": "Africa", "difficulty": 3},
    {"iso_code": "DZ", "name_es": "Argelia", "capital_es": "Argel", "continent": "Africa", "difficulty": 2},
    {"iso_code": "EG", "name_es": "Egipto", "capital_es": "El Cairo", "continent": "Africa", "difficulty": 1},
    {"iso_code": "ER", "name_es": "Eritrea", "capital_es": "Asmara", "continent": "Africa", "difficulty": 3},
    {"iso_code": "ET", "name_es": "Etiopía", "capital_es": "Adís Abeba", "continent": "Africa", "difficulty": 2},
    {"iso_code": "GA", "name_es": "Gabón", "capital_es": "Libreville", "continent": "Africa", "difficulty": 3},
    {"iso_code": "GH", "name_es": "Ghana", "capital_es": "Acra", "continent": "Africa", "difficulty": 2},
    {"iso_code": "GM", "name_es": "Gambia", "capital_es": "Banjul", "continent": "Africa", "difficulty": 3},
    {"iso_code": "GN", "name_es": "Guinea", "capital_es": "Conakri", "continent": "Africa", "difficulty": 3},
    {"iso_code": "GQ", "name_es": "Guinea Ecuatorial", "capital_es": "Malabo", "continent": "Africa", "difficulty": 2},
    {"iso_code": "GW", "name_es": "Guinea-Bisáu", "capital_es": "Bisáu", "continent": "Africa", "difficulty": 3},
    {"iso_code": "KE", "name_es": "Kenia", "capital_es": "Nairobi", "continent": "Africa", "difficulty": 2},
    {"iso_code": "KM", "name_es": "Comoras", "capital_es": "Moroni", "continent": "Africa", "difficulty": 3},
    {"iso_code": "LR", "name_es": "Liberia", "capital_es": "Monrovia", "continent": "Africa", "difficulty": 3},
    {"iso_code": "LS", "name_es": "Lesoto", "capital_es": "Maseru", "continent": "Africa", "difficulty": 3},
    {"iso_code": "LY", "name_es": "Libia", "capital_es": "Trípoli", "continent": "Africa", "difficulty": 2},
    {"iso_code": "MA", "name_es": "Marruecos", "capital_es": "Rabat", "continent": "Africa", "difficulty": 1},
    {"iso_code": "MG", "name_es": "Madagascar", "capital_es": "Antananarivo", "continent": "Africa", "difficulty": 2},
    {"iso_code": "ML", "name_es": "Malí", "capital_es": "Bamako", "continent": "Africa", "difficulty": 3},
    {"iso_code": "MR", "name_es": "Mauritania", "capital_es": "Nuakchot", "continent": "Africa", "difficulty": 3},
    {"iso_code": "MU", "name_es": "Mauricio", "capital_es": "Port Louis", "continent": "Africa", "difficulty": 3},
    {"iso_code": "MW", "name_es": "Malaui", "capital_es": "Lilongüe", "continent": "Africa", "difficulty": 3},
    {"iso_code": "MZ", "name_es": "Mozambique", "capital_es": "Maputo", "continent": "Africa", "difficulty": 3},
    {"iso_code": "NA", "name_es": "Namibia", "capital_es": "Windhoek", "continent": "Africa", "difficulty": 3},
    {"iso_code": "NE", "name_es": "Níger", "capital_es": "Niamey", "continent": "Africa", "difficulty": 3},
    {"iso_code": "NG", "name_es": "Nigeria", "capital_es": "Abuya", "continent": "Africa", "difficulty": 2},
    {"iso_code": "RW", "name_es": "Ruanda", "capital_es": "Kigali", "continent": "Africa", "difficulty": 3},
    {"iso_code": "SC", "name_es": "Seychelles", "capital_es": "Victoria", "continent": "Africa", "difficulty": 3},
    {"iso_code": "SD", "name_es": "Sudán", "capital_es": "Jartum", "continent": "Africa", "difficulty": 2},
    {"iso_code": "SL", "name_es": "Sierra Leona", "capital_es": "Freetown", "continent": "Africa", "difficulty": 3},
    {"iso_code": "SN", "name_es": "Senegal", "capital_es": "Dakar", "continent": "Africa", "difficulty": 2},
    {"iso_code": "SO", "name_es": "Somalia", "capital_es": "Mogadiscio", "continent": "Africa", "difficulty": 3},
    {"iso_code": "SS", "name_es": "Sudán del Sur", "capital_es": "Yuba", "continent": "Africa", "difficulty": 3},
    {"iso_code": "ST", "name_es": "Santo Tomé y Príncipe", "capital_es": "Santo Tomé", "continent": "Africa", "difficulty": 3},
    {"iso_code": "SZ", "name_es": "Esuatini", "capital_es": "Mbabane", "continent": "Africa", "difficulty": 3},
    {"iso_code": "TD", "name_es": "Chad", "capital_es": "Yamena", "continent": "Africa", "difficulty": 3},
    {"iso_code": "TG", "name_es": "Togo", "capital_es": "Lomé", "continent": "Africa", "difficulty": 3},
    {"iso_code": "TN", "name_es": "Túnez", "capital_es": "Túnez", "continent": "Africa", "difficulty": 2},
    {"iso_code": "TZ", "name_es": "Tanzania", "capital_es": "Dodoma", "continent": "Africa", "difficulty": 2},
    {"iso_code": "UG", "name_es": "Uganda", "capital_es": "Kampala", "continent": "Africa", "difficulty": 3},
    {"iso_code": "ZA", "name_es": "Sudáfrica", "capital_es": "Pretoria", "continent": "Africa", "difficulty": 1},
    {"iso_code": "ZM", "name_es": "Zambia", "capital_es": "Lusaka", "continent": "Africa", "difficulty": 3},
    {"iso_code": "ZW", "name_es": "Zimbabue", "capital_es": "Harare", "continent": "Africa", "difficulty": 3},

    # Americas (35)
    {"iso_code": "AG", "name_es": "Antigua y Barbuda", "capital_es": "Saint John", "continent": "Americas", "difficulty": 3},
    {"iso_code": "AR", "name_es": "Argentina", "capital_es": "Buenos Aires", "continent": "Americas", "difficulty": 1},
    {"iso_code": "BB", "name_es": "Barbados", "capital_es": "Bridgetown", "continent": "Americas", "difficulty": 3},
    {"iso_code": "BO", "name_es": "Bolivia", "capital_es": "Sucre", "continent": "Americas", "difficulty": 2},
    {"iso_code": "BR", "name_es": "Brasil", "capital_es": "Brasilia", "continent": "Americas", "difficulty": 1},
    {"iso_code": "BS", "name_es": "Bahamas", "capital_es": "Nasáu", "continent": "Americas", "difficulty": 2},
    {"iso_code": "BZ", "name_es": "Belice", "capital_es": "Belmopán", "continent": "Americas", "difficulty": 3},
    {"iso_code": "CA", "name_es": "Canadá", "capital_es": "Ottawa", "continent": "Americas", "difficulty": 1},
    {"iso_code": "CL", "name_es": "Chile", "capital_es": "Santiago", "continent": "Americas", "difficulty": 1},
    {"iso_code": "CO", "name_es": "Colombia", "capital_es": "Bogotá", "continent": "Americas", "difficulty": 1},
    {"iso_code": "CR", "name_es": "Costa Rica", "capital_es": "San José", "continent": "Americas", "difficulty": 2},
    {"iso_code": "CU", "name_es": "Cuba", "capital_es": "La Habana", "continent": "Americas", "difficulty": 1},
    {"iso_code": "DM", "name_es": "Dominica", "capital_es": "Roseau", "continent": "Americas", "difficulty": 3},
    {"iso_code": "DO", "name_es": "República Dominicana", "capital_es": "Santo Domingo", "continent": "Americas", "difficulty": 2},
    {"iso_code": "EC", "name_es": "Ecuador", "capital_es": "Quito", "continent": "Americas", "difficulty": 2},
    {"iso_code": "GD", "name_es": "Granada", "capital_es": "Saint George", "continent": "Americas", "difficulty": 3},
    {"iso_code": "GT", "name_es": "Guatemala", "capital_es": "Ciudad de Guatemala", "continent": "Americas", "difficulty": 2},
    {"iso_code": "GY", "name_es": "Guyana", "capital_es": "Georgetown", "continent": "Americas", "difficulty": 3},
    {"iso_code": "HN", "name_es": "Honduras", "capital_es": "Tegucigalpa", "continent": "Americas", "difficulty": 2},
    {"iso_code": "HT", "name_es": "Haití", "capital_es": "Puerto Príncipe", "continent": "Americas", "difficulty": 2},
    {"iso_code": "JM", "name_es": "Jamaica", "capital_es": "Kingston", "continent": "Americas", "difficulty": 2},
    {"iso_code": "KN", "name_es": "San Cristóbal y Nieves", "capital_es": "Basseterre", "continent": "Americas", "difficulty": 3},
    {"iso_code": "LC", "name_es": "Santa Lucía", "capital_es": "Castries", "continent": "Americas", "difficulty": 3},
    {"iso_code": "MX", "name_es": "México", "capital_es": "Ciudad de México", "continent": "Americas", "difficulty": 1},
    {"iso_code": "NI", "name_es": "Nicaragua", "capital_es": "Managua", "continent": "Americas", "difficulty": 2},
    {"iso_code": "PA", "name_es": "Panamá", "capital_es": "Ciudad de Panamá", "continent": "Americas", "difficulty": 2},
    {"iso_code": "PE", "name_es": "Perú", "capital_es": "Lima", "continent": "Americas", "difficulty": 1},
    {"iso_code": "PY", "name_es": "Paraguay", "capital_es": "Asunción", "continent": "Americas", "difficulty": 2},
    {"iso_code": "SR", "name_es": "Surinam", "capital_es": "Paramaribo", "continent": "Americas", "difficulty": 3},
    {"iso_code": "SV", "name_es": "El Salvador", "capital_es": "San Salvador", "continent": "Americas", "difficulty": 2},
    {"iso_code": "TT", "name_es": "Trinidad y Tobago", "capital_es": "Puerto España", "continent": "Americas", "difficulty": 3},
    {"iso_code": "US", "name_es": "Estados Unidos", "capital_es": "Washington D. C.", "continent": "Americas", "difficulty": 1},
    {"iso_code": "UY", "name_es": "Uruguay", "capital_es": "Montevideo", "continent": "Americas", "difficulty": 1},
    {"iso_code": "VC", "name_es": "San Vicente y las Granadinas", "capital_es": "Kingstown", "continent": "Americas", "difficulty": 3},
    {"iso_code": "VE", "name_es": "Venezuela", "capital_es": "Caracas", "continent": "Americas", "difficulty": 1},

    # Asia (47)
    {"iso_code": "AE", "name_es": "Emiratos Árabes Unidos", "capital_es": "Abu Dabi", "continent": "Asia", "difficulty": 2},
    {"iso_code": "AF", "name_es": "Afganistán", "capital_es": "Kabul", "continent": "Asia", "difficulty": 2},
    {"iso_code": "AM", "name_es": "Armenia", "capital_es": "Ereván", "continent": "Asia", "difficulty": 3},
    {"iso_code": "AZ", "name_es": "Azerbaiyán", "capital_es": "Bakú", "continent": "Asia", "difficulty": 3},
    {"iso_code": "BD", "name_es": "Bangladés", "capital_es": "Daca", "continent": "Asia", "difficulty": 2},
    {"iso_code": "BH", "name_es": "Baréin", "capital_es": "Manama", "continent": "Asia", "difficulty": 3},
    {"iso_code": "BN", "name_es": "Brunéi", "capital_es": "Bandar Seri Begawan", "continent": "Asia", "difficulty": 3},
    {"iso_code": "BT", "name_es": "Bután", "capital_es": "Timbu", "continent": "Asia", "difficulty": 3},
    {"iso_code": "CN", "name_es": "China", "capital_es": "Pekín", "continent": "Asia", "difficulty": 1},
    {"iso_code": "CY", "name_es": "Chipre", "capital_es": "Nicosia", "continent": "Asia", "difficulty": 2},
    {"iso_code": "GE", "name_es": "Georgia", "capital_es": "Tiflis", "continent": "Asia", "difficulty": 3},
    {"iso_code": "ID", "name_es": "Indonesia", "capital_es": "Yakarta", "continent": "Asia", "difficulty": 2},
    {"iso_code": "IL", "name_es": "Israel", "capital_es": "Jerusalén", "continent": "Asia", "difficulty": 1},
    {"iso_code": "IN", "name_es": "India", "capital_es": "Nueva Delhi", "continent": "Asia", "difficulty": 1},
    {"iso_code": "IQ", "name_es": "Irak", "capital_es": "Bagdad", "continent": "Asia", "difficulty": 2},
    {"iso_code": "IR", "name_es": "Irán", "capital_es": "Teherán", "continent": "Asia", "difficulty": 2},
    {"iso_code": "JO", "name_es": "Jordania", "capital_es": "Amán", "continent": "Asia", "difficulty": 2},
    {"iso_code": "JP", "name_es": "Japón", "capital_es": "Tokio", "continent": "Asia", "difficulty": 1},
    {"iso_code": "KG", "name_es": "Kirguistán", "capital_es": "Biskek", "continent": "Asia", "difficulty": 3},
    {"iso_code": "KH", "name_es": "Camboya", "capital_es": "Nom Pen", "continent": "Asia", "difficulty": 3},
    {"iso_code": "KP", "name_es": "Corea del Norte", "capital_es": "Pionyang", "continent": "Asia", "difficulty": 2},
    {"iso_code": "KR", "name_es": "Corea del Sur", "capital_es": "Seúl", "continent": "Asia", "difficulty": 1},
    {"iso_code": "KW", "name_es": "Kuwait", "capital_es": "Kuwait", "continent": "Asia", "difficulty": 2},
    {"iso_code": "KZ", "name_es": "Kazajistán", "capital_es": "Astaná", "continent": "Asia", "difficulty": 2},
    {"iso_code": "LA", "name_es": "Laos", "capital_es": "Vientián", "continent": "Asia", "difficulty": 3},
    {"iso_code": "LB", "name_es": "Líbano", "capital_es": "Beirut", "continent": "Asia", "difficulty": 2},
    {"iso_code": "LK", "name_es": "Sri Lanka", "capital_es": "Colombo", "continent": "Asia", "difficulty": 3},
    {"iso_code": "MM", "name_es": "Myanmar", "capital_es": "Naipyidó", "continent": "Asia", "difficulty": 3},
    {"iso_code": "MN", "name_es": "Mongolia", "capital_es": "Ulán Bator", "continent": "Asia", "difficulty": 3},
    {"iso_code": "MV", "name_es": "Maldivas", "capital_es": "Malé", "continent": "Asia", "difficulty": 3},
    {"iso_code": "MY", "name_es": "Malasia", "capital_es": "Kuala Lumpur", "continent": "Asia", "difficulty": 2},
    {"iso_code": "NP", "name_es": "Nepal", "capital_es": "Katmandú", "continent": "Asia", "difficulty": 2},
    {"iso_code": "OM", "name_es": "Omán", "capital_es": "Mascate", "continent": "Asia", "difficulty": 3},
    {"iso_code": "PH", "name_es": "Filipinas", "capital_es": "Manila", "continent": "Asia", "difficulty": 2},
    {"iso_code": "PK", "name_es": "Pakistán", "capital_es": "Islamabad", "continent": "Asia", "difficulty": 2},
    {"iso_code": "PS", "name_es": "Palestina", "capital_es": "Ramala", "continent": "Asia", "difficulty": 2},
    {"iso_code": "QA", "name_es": "Catar", "capital_es": "Doha", "continent": "Asia", "difficulty": 2},
    {"iso_code": "SA", "name_es": "Arabia Saudita", "capital_es": "Riad", "continent": "Asia", "difficulty": 1},
    {"iso_code": "SG", "name_es": "Singapur", "capital_es": "Singapur", "continent": "Asia", "difficulty": 2},
    {"iso_code": "SY", "name_es": "Siria", "capital_es": "Damasco", "continent": "Asia", "difficulty": 2},
    {"iso_code": "TH", "name_es": "Tailandia", "capital_es": "Bangkok", "continent": "Asia", "difficulty": 1},
    {"iso_code": "TJ", "name_es": "Tayikistán", "capital_es": "Dusambé", "continent": "Asia", "difficulty": 3},
    {"iso_code": "TL", "name_es": "Timor Oriental", "capital_es": "Dili", "continent": "Asia", "difficulty": 3},
    {"iso_code": "TM", "name_es": "Turkmenistán", "capital_es": "Asjabad", "continent": "Asia", "difficulty": 3},
    {"iso_code": "TR", "name_es": "Turquía", "capital_es": "Ankara", "continent": "Asia", "difficulty": 1},
    {"iso_code": "UZ", "name_es": "Uzbekistán", "capital_es": "Taskent", "continent": "Asia", "difficulty": 3},
    {"iso_code": "VN", "name_es": "Vietnam", "capital_es": "Hanói", "continent": "Asia", "difficulty": 2},
    {"iso_code": "YE", "name_es": "Yemen", "capital_es": "Saná", "continent": "Asia", "difficulty": 3},

    # Europe (45)
    {"iso_code": "AD", "name_es": "Andorra", "capital_es": "Andorra la Vieja", "continent": "Europe", "difficulty": 3},
    {"iso_code": "AL", "name_es": "Albania", "capital_es": "Tirana", "continent": "Europe", "difficulty": 3},
    {"iso_code": "AT", "name_es": "Austria", "capital_es": "Viena", "continent": "Europe", "difficulty": 2},
    {"iso_code": "BA", "name_es": "Bosnia y Herzegovina", "capital_es": "Sarajevo", "continent": "Europe", "difficulty": 3},
    {"iso_code": "BE", "name_es": "Bélgica", "capital_es": "Bruselas", "continent": "Europe", "difficulty": 1},
    {"iso_code": "BG", "name_es": "Bulgaria", "capital_es": "Sofía", "continent": "Europe", "difficulty": 2},
    {"iso_code": "BY", "name_es": "Bielorrusia", "capital_es": "Minsk", "continent": "Europe", "difficulty": 3},
    {"iso_code": "CH", "name_es": "Suiza", "capital_es": "Berna", "continent": "Europe", "difficulty": 1},
    {"iso_code": "CZ", "name_es": "Chequia", "capital_es": "Praga", "continent": "Europe", "difficulty": 2},
    {"iso_code": "DE", "name_es": "Alemania", "capital_es": "Berlín", "continent": "Europe", "difficulty": 1},
    {"iso_code": "DK", "name_es": "Dinamarca", "capital_es": "Copenhague", "continent": "Europe", "difficulty": 2},
    {"iso_code": "EE", "name_es": "Estonia", "capital_es": "Tallin", "continent": "Europe", "difficulty": 3},
    {"iso_code": "ES", "name_es": "España", "capital_es": "Madrid", "continent": "Europe", "difficulty": 1},
    {"iso_code": "FI", "name_es": "Finlandia", "capital_es": "Helsinki", "continent": "Europe", "difficulty": 2},
    {"iso_code": "FR", "name_es": "Francia", "capital_es": "París", "continent": "Europe", "difficulty": 1},
    {"iso_code": "GB", "name_es": "Reino Unido", "capital_es": "Londres", "continent": "Europe", "difficulty": 1},
    {"iso_code": "GR", "name_es": "Grecia", "capital_es": "Atenas", "continent": "Europe", "difficulty": 1},
    {"iso_code": "HR", "name_es": "Croacia", "capital_es": "Zagreb", "continent": "Europe", "difficulty": 2},
    {"iso_code": "HU", "name_es": "Hungría", "capital_es": "Budapest", "continent": "Europe", "difficulty": 2},
    {"iso_code": "IE", "name_es": "Irlanda", "capital_es": "Dublín", "continent": "Europe", "difficulty": 2},
    {"iso_code": "IS", "name_es": "Islandia", "capital_es": "Reikiavik", "continent": "Europe", "difficulty": 2},
    {"iso_code": "IT", "name_es": "Italia", "capital_es": "Roma", "continent": "Europe", "difficulty": 1},
    {"iso_code": "LI", "name_es": "Liechtenstein", "capital_es": "Vaduz", "continent": "Europe", "difficulty": 3},
    {"iso_code": "LT", "name_es": "Lituania", "capital_es": "Vilna", "continent": "Europe", "difficulty": 3},
    {"iso_code": "LU", "name_es": "Luxemburgo", "capital_es": "Luxemburgo", "continent": "Europe", "difficulty": 2},
    {"iso_code": "LV", "name_es": "Letonia", "capital_es": "Riga", "continent": "Europe", "difficulty": 3},
    {"iso_code": "MC", "name_es": "Mónaco", "capital_es": "Mónaco", "continent": "Europe", "difficulty": 2},
    {"iso_code": "MD", "name_es": "Moldavia", "capital_es": "Chisináu", "continent": "Europe", "difficulty": 3},
    {"iso_code": "ME", "name_es": "Montenegro", "capital_es": "Podgorica", "continent": "Europe", "difficulty": 3},
    {"iso_code": "MK", "name_es": "Macedonia del Norte", "capital_es": "Skopie", "continent": "Europe", "difficulty": 3},
    {"iso_code": "MT", "name_es": "Malta", "capital_es": "La Valeta", "continent": "Europe", "difficulty": 3},
    {"iso_code": "NL", "name_es": "Países Bajos", "capital_es": "Ámsterdam", "continent": "Europe", "difficulty": 1},
    {"iso_code": "NO", "name_es": "Noruega", "capital_es": "Oslo", "continent": "Europe", "difficulty": 2},
    {"iso_code": "PL", "name_es": "Polonia", "capital_es": "Varsovia", "continent": "Europe", "difficulty": 2},
    {"iso_code": "PT", "name_es": "Portugal", "capital_es": "Lisboa", "continent": "Europe", "difficulty": 1},
    {"iso_code": "RO", "name_es": "Rumania", "capital_es": "Bucarest", "continent": "Europe", "difficulty": 2},
    {"iso_code": "RS", "name_es": "Serbia", "capital_es": "Belgrado", "continent": "Europe", "difficulty": 3},
    {"iso_code": "RU", "name_es": "Rusia", "capital_es": "Moscú", "continent": "Europe", "difficulty": 1},
    {"iso_code": "SE", "name_es": "Suecia", "capital_es": "Estocolmo", "continent": "Europe", "difficulty": 2},
    {"iso_code": "SI", "name_es": "Eslovenia", "capital_es": "Liubliana", "continent": "Europe", "difficulty": 3},
    {"iso_code": "SK", "name_es": "Eslovaquia", "capital_es": "Bratislava", "continent": "Europe", "difficulty": 3},
    {"iso_code": "SM", "name_es": "San Marino", "capital_es": "San Marino", "continent": "Europe", "difficulty": 3},
    {"iso_code": "UA", "name_es": "Ucrania", "capital_es": "Kiev", "continent": "Europe", "difficulty": 2},
    {"iso_code": "VA", "name_es": "Ciudad del Vaticano", "capital_es": "Ciudad del Vaticano", "continent": "Europe", "difficulty": 2},

    # Oceania (14)
    {"iso_code": "AU", "name_es": "Australia", "capital_es": "Canberra", "continent": "Oceania", "difficulty": 1},
    {"iso_code": "FJ", "name_es": "Fiyi", "capital_es": "Suva", "continent": "Oceania", "difficulty": 3},
    {"iso_code": "FM", "name_es": "Micronesia", "capital_es": "Palikir", "continent": "Oceania", "difficulty": 3},
    {"iso_code": "KI", "name_es": "Kiribati", "capital_es": "Tarawa Sur", "continent": "Oceania", "difficulty": 3},
    {"iso_code": "MH", "name_es": "Islas Marshall", "capital_es": "Majuro", "continent": "Oceania", "difficulty": 3},
    {"iso_code": "NR", "name_es": "Nauru", "capital_es": "Yaren", "continent": "Oceania", "difficulty": 3},
    {"iso_code": "NZ", "name_es": "Nueva Zelanda", "capital_es": "Wellington", "continent": "Oceania", "difficulty": 1},
    {"iso_code": "PG", "name_es": "Papúa Nueva Guinea", "capital_es": "Port Moresby", "continent": "Oceania", "difficulty": 3},
    {"iso_code": "PW", "name_es": "Palaos", "capital_es": "Ngerulmud", "continent": "Oceania", "difficulty": 3},
    {"iso_code": "SB", "name_es": "Islas Salomón", "capital_es": "Honiara", "continent": "Oceania", "difficulty": 3},
    {"iso_code": "TO", "name_es": "Tonga", "capital_es": "Nukualofa", "continent": "Oceania", "difficulty": 3},
    {"iso_code": "TV", "name_es": "Tuvalu", "capital_es": "Funafuti", "continent": "Oceania", "difficulty": 3},
    {"iso_code": "VU", "name_es": "Vanuatu", "capital_es": "Port Vila", "continent": "Oceania", "difficulty": 3},
    {"iso_code": "WS", "name_es": "Samoa", "capital_es": "Apia", "continent": "Oceania", "difficulty": 3},
]

def main():
    root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    data_dir = os.path.join(root_dir, "assets", "data")
    flags_dir = os.path.join(root_dir, "assets", "flags")

    os.makedirs(data_dir, exist_ok=True)
    os.makedirs(flags_dir, exist_ok=True)

    db_path = os.path.join(data_dir, "countries.db")
    if os.path.exists(db_path):
        os.remove(db_path)

    print(f"Total countries defined: {len(COUNTRIES)}")
    assert len(COUNTRIES) == 195, f"Expected 195 countries, got {len(COUNTRIES)}"

    # Check uniqueness of ISO2 codes
    iso_codes = [c["iso_code"] for c in COUNTRIES]
    assert len(set(iso_codes)) == 195, f"Duplicate ISO codes found!"

    # Create SQLite database
    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    cur.execute("PRAGMA user_version = 1;")
    cur.execute("""
        CREATE TABLE countries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            iso_code TEXT NOT NULL,
            name_es TEXT NOT NULL,
            capital_es TEXT NOT NULL,
            continent TEXT NOT NULL,
            difficulty INTEGER NOT NULL,
            flag_asset_path TEXT NOT NULL
        );
    """)

    for country in sorted(COUNTRIES, key=lambda x: x["iso_code"]):
        flag_path = f"assets/flags/{country['iso_code'].lower()}.svg"
        cur.execute("""
            INSERT INTO countries (iso_code, name_es, capital_es, continent, difficulty, flag_asset_path)
            VALUES (?, ?, ?, ?, ?, ?)
        """, (
            country["iso_code"],
            country["name_es"],
            country["capital_es"],
            country["continent"],
            country["difficulty"],
            flag_path
        ))

    conn.commit()
    conn.close()
    print(f"Created SQLite DB at {db_path} with user_version = 1")

    # Download flags
    print("Downloading SVG flags...")
    success_count = 0
    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"}

    for country in COUNTRIES:
        iso_lower = country["iso_code"].lower()
        flag_file = os.path.join(flags_dir, f"{iso_lower}.svg")

        # Check if already exists and is valid
        if os.path.exists(flag_file) and os.path.getsize(flag_file) > 100:
            with open(flag_file, "r", encoding="utf-8", errors="ignore") as f:
                if "<svg" in f.read():
                    success_count += 1
                    continue

        # Try FlagCDN first, fallback to lipis/flag-icons
        urls = [
            f"https://flagcdn.com/{iso_lower}.svg",
            f"https://raw.githubusercontent.com/lipis/flag-icons/main/flags/4x3/{iso_lower}.svg"
        ]

        downloaded = False
        for url in urls:
            try:
                req = urllib.request.Request(url, headers=headers)
                with urllib.request.urlopen(req, timeout=10) as resp:
                    data = resp.read()
                    if b"<svg" in data:
                        with open(flag_file, "wb") as f:
                            f.write(data)
                        downloaded = True
                        success_count += 1
                        break
            except Exception as e:
                pass

        if not downloaded:
            print(f"FAILED to download flag for {country['iso_code']} ({country['name_es']})")
        else:
            print(f"Downloaded flag for {country['iso_code']} ({country['name_es']})")

    print(f"SVG download complete. Total valid flags: {success_count}/195")

if __name__ == "__main__":
    main()
