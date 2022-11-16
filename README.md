## Notes

In the event of an issue when attempting to run `bundle install` that a message that matches the following:

```
Your bundle only supports platforms ["arm64-darwin-21"] but your local platform
is x86_64-linux. Add the current platform to the lockfile with
`bundle lock --add-platform x86_64-linux` and try again.
```

Try running the suggested command to pull in the necessary platform-specific dependencies.