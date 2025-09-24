function(env, branch)
  {
    apiVersion: 'argoproj.io/v1alpha1',
    kind: 'Application',
    metadata: {
      name: env + '-hello-server',
      namespace: 'argocd',
      finalizers: [
        'resources-finalizer.argocd.argoproj.io',
      ],
    },
    spec: {
      project: 'default',
      source: {
        repoURL: 'https://github.com/nojima/hello-server',
        targetRevision: branch,
        path: 'kubernetes',
        directory: {
          jsonnet: {
            tlas: [
              {
                name: 'tag',
                value: '$ARGOCD_APP_REVISION',
              },
              {
                name: 'message',
                value: 'Hello World (%s)' % env,
              },
            ],
          },
        },
      },
      destination: {
        server: 'https://kubernetes.default.svc',
        namespace: env + '-hello-server',
      },
      syncPolicy: {
        automated: {
          prune: true,
          selfHeal: true,
        },
      },
    },
  }
