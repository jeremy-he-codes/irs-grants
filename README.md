# README

* Ruby version: 2.7.2
* Node version: ^16.10.0
* DB: Sqlite
## How to setup and run
- Clone the repo
- `bundle` to setup Ruby gems
- `yarn` to setup Node packages
- `rails db:migrate` or `bundle exec rake db:migrate` to setup Sqlite DB and create schema
- `rails s` to run the application

The application up and running on `localhost:3000`.

## How to import data
- `rails console` to open the rails console from your terminal
- use `FilingImporter.import(<xml file url>)` to import a specific IRS filing document.  
    i.e. `FilingImporter.import('http://s3.amazonaws.com/irs-form-990/201132069349300318_public.xml')`

# Further Thoughts
There still are multitudes of areas where the improvement is due.
The list of future enhancements (skipped due to time constraints) includes but is not limited to:
- Write tests on Ruby on Rails modules, using RSpec
- Make a more encompassing parser for different types of IRS filing doc structure (some files have totally different structures).  
    i.e. http://s3.amazonaws.com/irs-form-990/201522139349100402_public.xml
- Write a better and deeper search logic for recipients
- Add some search functionality to filers/filings/awards endpoints
- Implement pagination/sorting on listing endpoints
- (Front-end) do a better styling
- (Front-end) implement pagination/sorting on tables
- (Front-end) incorporate a better feedback system for failures
- (Front-end) put together a more human-readable, search-friendly urls.  
    i.e. filing year instead of filing id in the url, filer slug instead of filer id in the url
- (Front-end) extend the state management to the full.  
    right now, it is covering only a very small number of cases
- Implement a better logging for `FilingImporter`
- Build an admin UI where one can put URLs and trigger the imports, rather than using rails console
- Make use of workers/jobs for the above case
- ...
