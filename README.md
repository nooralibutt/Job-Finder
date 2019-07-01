# Job Finder

## Job Listing View

Main view has two text field filters on which you manually have to enter data and press go button.
By default github search is selected, you can select any one of the service provider

## Job Detail View 

On clicking any cell item, app display a webview and load the job details in couple of seconds

## Progress HUD

It's a library I use to show a tooltip like loading

## Network Manager & Connectivity

Network manager handles the connection to server and parse the response and return in APIResponse Model. Connectivity class handles if app is connected to internet

## Job Model

ApiResponse is returned by network manager and later every service provider handles it according to its parameter arrangements and naming conventions 

## Service Providers

There is a protocol named as ServiceProvider which should be implemented for any additional service provider. Here are the steps one need to implement:

// 1: Change name
var name: String { return "Search.Gov" }

// 2: Provide base URL
var baseURL = "https://jobs.search.gov/jobs/search.json"

3: Provide your own query system

// 4: Provide your own parsing
func parseResponse(json: [String: Any]) -> Job {
