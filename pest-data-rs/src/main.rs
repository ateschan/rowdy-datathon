use csv::ReaderBuilder;
use std::fs::File;
use std::{error::Error, io, process};
use serde::Deserialize;

#[derive(Debug, Deserialize)]
struct Data {
    #[serde(rename = "Sample ID")]
    sample_id: Option<String>, // Sample ID

    #[serde(rename = "Commod")]
    commod: Option<String>, // Commod

    #[serde(rename = "Pesticide Code")]
    pesticide_code: Option<String>, // Pesticide Code

    #[serde(rename = "Pesticide Name")]
    pesticide_name: Option<String>, // Pesticide Name

    #[serde(rename = "Test Class")]
    test_class: Option<String>, // Test Class

    #[serde(rename = "Concentration")]
    concentration: Option<f32>, // Concentration

    #[serde(rename = "LOD")]
    lod: Option<f32>, // LOD

    #[serde(rename = "pp_")]
    pp_: Option<String>, // Parts per x

    #[serde(rename = "Confirm 1")]
    confirm_1: Option<String>, // Confirm 1

    #[serde(rename = "Confirm 2")]
    confirm_2: Option<String>, // Confirm 2

    #[serde(rename = "Annotate")]
    annotate: Option<String>, // Annotate

    #[serde(rename = "Quantitate")]
    quantitate: Option<String>, // Quantitate

    #[serde(rename = "Mean")]
    mean: Option<String>, // Mean

    #[serde(rename = "Extract")]
    extract: Option<String>, // Extract

    #[serde(rename = "Determ")]
    determ: Option<String>, // Determ

    #[serde(rename = "EPA Tolerance (ppm)")]
    epa_tolerance_ppm: Option<String>, // EPA Tolerance (ppm)
}

#[derive(PartialEq, Debug)]
struct StateEntry {
    state: String,
    samplect: f32,
    raw_conc: f32,
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
    let file_path = "./USDA_PDP_AnalyticalResults.csv"; // Replace with your actual CSV file path
    let mut samples = read_csv(file_path)?;
    println!("Year,State,Avg");
    // For Year
    for year in 6..23 {
        let mut yearstr;
        if year > 9 {
            yearstr = year.to_string();
        } else {
            yearstr = "0".to_owned() + &year.to_string();
        }

        let mut StatePool: Vec<StateEntry> = Vec::new();
        for sample in samples.iter_mut() {
            if sample.pesticide_name.clone().unwrap() == "Thiamethoxam" || sample.pesticide_name.clone().unwrap() == "Clothianidin" || sample.pesticide_name.clone().unwrap() =="Imidacloprid" {
            if sample.sample_id.clone().unwrap()[2..4] == yearstr {
                if sample.pp_.clone().unwrap() == "T" {
                    sample.concentration = Some(sample.concentration.unwrap() / 1000.0);
                }
                let mut f = false;
                for i in StatePool.iter_mut() {
                    if sample.sample_id.clone().unwrap()[0..2] == i.state {
                        i.raw_conc += sample.concentration.unwrap();
                        i.samplect += 1.0;
                        f = true;
                    }
                }
                if !f {
                    StatePool.push(StateEntry {
                        state: sample.sample_id.clone().unwrap()[0..2].to_owned(),
                        samplect: 1.0,
                        raw_conc: sample.concentration.unwrap(),
                    });
                }
            }
            }
        }
        for state in StatePool {
            print!(
                "{},{},{}\n",
                year,
                state.state,
                state.raw_conc / state.samplect
            );
        }
    }

    Ok(())
}
