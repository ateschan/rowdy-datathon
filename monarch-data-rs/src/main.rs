use csv::ReaderBuilder;
use serde::Deserialize;
use std::fs::File;
use std::error::Error;

#[derive(Debug, Deserialize)]
struct Data {
    #[serde(rename = "Year")]
    year: String,

    #[serde(rename = "State")]
    state: String,

    #[serde(rename = "Sightings")]
    sightings: Option<i32>,
}

#[derive(PartialEq, Debug)]
struct StateEntry {
    state: String,
    sightings: i32,
}

fn read_csv(file_path: &str) -> Result<Vec<Data>, Box<dyn Error>> {
    let mut rdr = ReaderBuilder::new()
        .has_headers(true)
        .from_reader(File::open(file_path)?);

    let mut samples: Vec<Data> = Vec::new();

    for result in rdr.deserialize() {
        let record: Data = result?;
        samples.push(record);
    }

    Ok(samples)
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "./MonarchsJourneyNorth.csv"; // Replace with your actual CSV file path
    let samples = read_csv(file_path)?;

    // For Year
    for year in 5..=22 {
        let yearstr = format!("{:02}", year); // Ensures leading zero for single digits

        let mut state_pool: Vec<StateEntry> = Vec::new();

        for sample in &samples {
            if sample.year == yearstr { // No need to call to_string() here
                if let Some(a) = sample.sightings {
                    let entry = state_pool.iter_mut().find(|i| i.state == sample.state);
                    match entry {
                        Some(state_entry) => {
                            state_entry.sightings += a; // Update existing entry
                        }
                        None => {
                            state_pool.push(StateEntry {
                                state: sample.state.clone(),
                                sightings: a,
                            }); // Add new entry
                        }
                    }
                }
            }
        }

        for state in state_pool {
            if state.state.len() == 2  {
                println!("{},{},{}", yearstr, state.state, state.sightings);
            }
        }
    }

    Ok(())
}
