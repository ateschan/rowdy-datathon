


import requests
from bs4 import BeautifulSoup
for y in range(1998, 2024):
    url = "https://journeynorth.org/sightings/querylist.html?season=fall&map=monarch-adult-fall&year="+str(y)+"&submit=View+Data"

    response = requests.get(url)
    if response.status_code == 200:
        soup = BeautifulSoup(response.text, 'html.parser')
        table = soup.find('table')
        if table:
            rows = table.find_all('tr')
            for row in rows[1:]:
                columns = row.find_all('td')
                ColumTXT = [column.text.strip() for column in columns]
                print("Row Columns:", ColumTXT)
                if len(columns) >= 7:  
                    date = columns[1].text.strip()           
                    town = columns[2].text.strip()           
                    state = columns[3].text.strip()          
                    NumbOfSight = columns[6].text.strip()   
                    print(f"Date: {date}, Town: {town}, State: {state}, Number of Sightings: {NumbOfSight}")
        else:
            print("Could not find table.")

