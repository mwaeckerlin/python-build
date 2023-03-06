# Docker Image to Build Python Software

Use this image to build your python packages, use [mwaeckerlin/python](https://github.com/mwaeckerlin/python) for the final build stage. That image has no shell and nothing you don't need.

Simple example:

```
FROM mwaeckerlin/python-build AS build
ADD requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt
ADD . /app

FROM mwaeckerlin/python
COPY --from=build /app /app
COPY --from=build /home/${BUILD_USER}/.local/lib /home/${RUN_USER}/.local/lib
```

If you need to install more python packages from Alpine, then add them in the build step, run `sh -c "$ADD_MODULES"` to copy the required files to `/tmp/root`, then copy `/tmp/root` in the final stage.

In that case, your `Dockerfile` may look like this:
```
FROM mwaeckerlin/python-build AS build
USER root
RUN $PKG_INSTALL py3-pandas py3-yaml
RUN sh -c "$ADD_MODULES"
USER $BUILD_USER
ADD requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt
ADD . /app

FROM mwaeckerlin/python
COPY --from=build /tmp/root /
COPY --from=build /app /app
COPY --from=build /home/${BUILD_USER}/.local/lib /home/${RUN_USER}/.local/lib
```
