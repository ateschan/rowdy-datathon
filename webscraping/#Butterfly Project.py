import requests
from bs4 import BeautifulSoup

with open("WebScraperText.txt", "w") as file:
    for y in range(1997, 2025):
        url = "https://journeynorth.org/sightings/querylist.html?season=fall&map=monarch-adult-fall&year=" + str(y) + "&submit=View+Data"

        response = requests.get(url)
        if response.status_code == 200:
            soup = BeautifulSoup(response.text, 'html.parser')
            table = soup.find('table')
            if table:
                rows = table.find_all('tr')
                for row in rows[1:]:
                    columns = row.find_all('td')
                    if len(columns) >= 7:
                        date = columns[1].text.strip()
                        town = columns[2].text.strip()
                        state = columns[3].text.strip()
                        NumOfSight = columns[6].text.strip()
                        file.write(f"Date: {date}, Town: {town}, State: {state}, Number of Sightings: {NumOfSight}\n")
            else:
                file.write("Could not find table.\n")
        else:
            file.write(f"Failed {y}\n")

