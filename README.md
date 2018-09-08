# Heaven adapter

## FAQ:
- Q: Why heaven?
- A: Can't think of other queues in the clouds 

- Q: Does this repo really needs this FAQ section?
- A: absolutely not, but it's fun to have one.

## How to:

1. Configure `config/initializers/heaven.rb` up to your liking.
2. Run worker: `rake heaven:run_worker`
3. Queue some tasks! Open your console: `rails c` and enjoy useless pre-built workers:
- `FailingJob.deliver_later('Your message')` – useless worker which loves to fail and does it all the time. 
- `SuccessJob.deliver_later('Printing message is an expensive operation thus BG job')` - this worker does not fail, but this quality doesn't add any real business value to it.

## Questions?
Better ask me directly :D

