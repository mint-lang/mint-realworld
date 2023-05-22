# Mint Realworld

> ### Mint codebase containing real world examples (CRUD, auth, advanced patterns, etc) that adheres to the [RealWorld](https://github.com/gothinkster/realworld) spec and API.

### [Demo](https://realworld.mint-lang.com)&nbsp;&nbsp;&nbsp;&nbsp;[RealWorld](https://github.com/gothinkster/realworld)


This codebase was created to demonstrate a fully fledged fullstack application built with [**Mint**](https://www.mint-lang.com) including CRUD operations, authentication, routing, pagination, and more.

We've gone to great lengths to adhere to the **Mint** community styleguides & best practices.

For more information on how to this works with other frontends/backends, head over to the [RealWorld](https://github.com/gothinkster/realworld) repo.


# How it works

This implemenation only uses the **Mint** language and it's standard library without any third party dependencies.

To learn more about **Mint** check out the [Guide](https://mint-lang.com/guide)

# Differences

There are a few difference to other implementations:
* since Mint has a built in way of styling HTML elements we wanted to showcase that, so the design of the
  application greatly differs from the original one
* the end result is also a Progressive Web App which is not included in the original spec
* the routes are not using hash

# Development Server

Follow these steps to get up and running:

1. Install Mint ( https://www.mint-lang.com/install )
2. Clone the repository
3. Install dependencies with `mint install`
4. Start the development server `mint start`
6. That's it!

# Production Build

Just run `mint build` and everything is built into the `dist` folder.

# Running Tests

Just run `mint test` to run the sample tests.
