# ProTweets

_Words of Wisdom from the Twitter-verse_

## Why?

We here at Fifth Room Creative decided that the world needed easy access to the words of collective wisdom that pass through Twitter on a daily basis. We're using this as an opportunity to learn about one another's talents, explore new ways of building sites, and have a good time on a Friday.

## How It Works

ProTweets is comprised of 2 scripts: a background worker and a Sinatra web application. The background worker runs as a Cron job and fetches new tweets into the database (SQLite by default), while the web app takes care of displaying them.

The database is handled by DataMapper, which is something that Mike's been wanting to try for a while now, and the frontend code will be handled by Twitter's Bootstrap (which Steve wanted to try).


## License

__Copyright (C) 2012 Fifth Room Creative__

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
