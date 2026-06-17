CREATE TABLE companies ( -- Table to store information about companies using the platform
    id SERIAL PRIMARY KEY, -- Unique identifier for each company using the platform
    name VARCHAR (255), -- The name of the company, e.g., "OpenAI", "Google", "Anthropic"
    industry VARCHAR (100), -- The industry the company operates in, e.g., 'Technology', 'Healthcare', 'Finance'
    region VARCHAR(100), -- The geographical region where the company is based, e.g., 'us-east-1'
    created_at TIMESTAMPTZ -- The date and time when the company was added to the database
);

CREATE TABLE ai_models ( -- Table to store information about AI models available on the platform
    id SERIAL PRIMARY KEY, -- Unique identifier for each AI model
    provider VARCHAR (100), -- The company providing the AI model, e.g., "OpenAI", "Google", "Anthropic"
    model_name VARCHAR (255), -- The name of the AI model, e.g., "GPT-4", "Bard", "Gemini"  
    model_type VARCHAR (50) -- The type of the AI model, e.g., "LLM", "Vision", "Multimodal"
);

CREATE TABLE ai_usage_sessions ( -- Table to store information about each AI usage session, including energy and carbon metrics 
    id BIGSERIAL PRIMARY KEY, -- Unique identifier for each AI usage session
    company_id INT REFERENCES companies(id), -- Foreign key referencing the company that used the AI model
    model_id INT REFERENCES ai_models(id), -- Foreign key referencing the AI model that was used
    session_type VARCHAR(20), -- The type of the AI usage session, e.g., 'inference', 'training'
    timestamp TIMESTAMPTZ, -- The date and time when the AI usage session occurred
    input_tokens INT, -- The number of tokens in the input to the AI model
    output_tokens INT, -- The number of tokens in the output from the AI model
    energy_consumed_wh DECIMAL(10,4), -- The amount of energy consumed during the AI usage session, in watt-hours
    carbon_emissions_kg DECIMAL(10,6), -- The amount of carbon emissions generated during the AI usage session, in kilograms
    water_consumed_ml DECIMAL(10,2), -- The amount of water consumed during the AI usage session, in milliliters
    response_time_ms DECIMAL(8,2), -- The response time of the AI model during the usage session, in milliseconds
    hardware_used VARCHAR(100), -- The hardware used during the AI usage session
    pue DECIMAL(4,3), -- The power usage effectiveness of the data center where the AI usage session occurred
    grid_carbon_intensity_gco2_per_kwh DECIMAL (8,2), -- The carbon intensity of the grid where the AI usage session occurred, in grams of CO2 per kWh
    region VARCHAR(100), -- The geographical region where the AI usage session occurred
    renewable_energy_percentage DECIMAL(5, 2) -- The percentage of renewable energy used in the data center where the AI usage session occurred
);

CREATE TABLE regional_factors ( -- Table to store regional factors that can be used to estimate energy and carbon metrics for AI usage sessions
    region VARCHAR(100) PRIMARY KEY, -- The geographical region, e.g., 'us-east-1', 'europe-west-1'
    avg_grid_carbon_intensity DECIMAL (8,2), -- The average carbon intensity of the grid in the region, in grams of CO2 per kWh
    water_stress_index DECIMAL (5,2), -- A measure of water stress in the region
    renewable_percentage DECIMAL (5,2), -- The percentage of renewable energy used in the region
    typical_pue DECIMAL(4,3) -- The typical power usage effectiveness of data centers in the region
);

CREATE TABLE users ( -- Table to store information about specific users per session
 company_id INT REFERENCES companies(id), -- Foreign key referencing the company the user belongs to
 id SERIAL PRIMARY KEY, -- Unique identifier for each user
 email VARCHAR(255) UNIQUE, -- The email address of the user, used for authentication and identification
 name VARCHAR(255), -- The full name of the user
 department VARCHAR(100), -- The department the user belongs to within the company, e.g., 'Engineering', 'Marketing', 'Sales'
 created_at TIMESTAMPTZ DEFAULT NOW() -- The date and time when the user was added to the database
);
