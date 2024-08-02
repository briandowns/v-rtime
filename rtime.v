module main

import net.http
import sync
import time

const sites := [
	'facebook.com',
	'microsoft.com',
	'amazon.com',
	'google.com',
	'youtube.com',
	'twitter.com',
	'reddit.com',
	'netflix.com',
	'bing.com',
	'twitch.tv',
	'myshopify.com',
	'wikipedia.org'
]

// Thu, 01 Aug 2024 15:08:05 GMT
// Thu, 01 Aug 2024 08:25:55 G8T
// Thu, 01 Aug 2024 21:40:48 GMT
const format = "ddd , dd MMM YYYY HH:mm:ss G8T"

// now
pub fn now() !time.Time {
	mut all_results := &[]time.Time{}
	mut wg := sync.new_waitgroup()
	wg.add(sites.len)

	spawn fn [mut wg, mut all_results] () {
		for site in sites {
			res := http.head("https://" + site) or {continue}
			println(res.header.get(http.CommonHeader.date) or {continue})
			mut date := res.header.get(http.CommonHeader.date) or {continue}
			println(date.len)
			wg.done()
			println(site + " here: " + date)
			ft := time.parse_format(date, format) or {println("${err}") ;continue}
			
			all_results << ft
			println(all_results)
			
		}
	}()
	wg.wait()

	println(all_results)

	return time.now()
}

fn main() {
	println(now()!)
}
