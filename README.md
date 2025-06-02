# 🧪 Prueba Técnica DevOps – Devsu

Este repositorio contiene la solución desarrollada para la **prueba técnica DevOps** propuesta por **Devsu**.

Como base del proyecto, se ha seleccionado la aplicación construida con **Node.js**, sobre la cual se han implementado las prácticas y herramientas DevOps requeridas.


## Estructura del Proyecto
```bash
.
|- .github/ # Workflows y acciones de GitHub (CI/CD).
|- ansible/ # Playbooks para aprovisionamiento y configuración con ansible.
|- docs/    # Documentaciones del proyecto. (Diagramas, evidencias, etc).
|- infra/   # Carpeta donde se encuentra Infraestructura con Terraform.
|- k8s/     # Manifiestos de Kubernetes
|- src/     # Código fuente de la aplicación seleccionada.
````

## ⚙️ Tecnologías Utilizadas

- **Kubeadm**
  Herramienta empleada para la inicialización y configuración del clúster de Kubernetes de manera manual y controlada.

- **Terraform**
  Utilizado para el aprovisionamiento y despliegue automatizado de la infraestructura como código (IaC), asegurando entornos reproducibles y escalables.

- **Ansible**
  Implementado para la gestión de configuración, automatización de tareas repetitivas y orquestación de servidores de forma declarativa.

- **GitHub Actions**
  Integración y entrega continua (CI/CD) mediante flujos de trabajo automatizados, permitiendo pruebas, compilación y despliegue del código de forma eficiente.


## 🌩️ Proveedor de Nube
Se utilizó Amazon Web Services (AWS) como proveedor de nube para aprovisionamiento y despliegue de infraestructura.

El entorno fue ejecutado en el AWS Academy Learner Lab, un laboratorio temporal y aislado que ofrece AWS para fines educativos a través de la plataforma AWS Academy.

## 🛠️ Despliegue de Infraestructura

### 📦 Prerrequisitos
Asegúrate de tener instaladas las siguientes herramientas en tu entorno local:

- [Git](https://git-scm.com/)
- [Terraform](https://www.terraform.io/downloads.html)

### Pasos a realizar
1. **Clonar Repositorio:**
  ````bash
    git clone https://github.com/soyjosue/prueba-devops.git
    cd .\devops-test\infra\
  ````
2. **Configurar credenciales AWS**
  ````bash
  export AWS_ACCESS_KEY_ID="TU_ACCESS_KEY"
  export AWS_SECRET_ACCESS_KEY="TU_SECRET_KEY"
  export AWS_SESSION_TOKEN="TU_SESSION_TOKEN" # Opcional, si estás usando sesión temporal
  ````
3. **Inicializar Terraform:**
  ````bash
    terraform init
  ````
4. **Planificar cambios**
  ````bash
    terraform plan
  ````
5. **Aplicar cambios**
  ````bash
    terraform apply
  ````

## 🔐 Configuración de Variables en GitHub Actions

### 🧭 Instrucciones

1. Accede al repositorio en GitHub.
2. Ve a **Settings**.
3. En el menú lateral, selecciona **Secrets and variables > Actions**.
4. Haz clic en **New repository secret** y añade las siguientes claves:

| Nombre del Secret           | Descripción                                                                 |
|----------------------------|-----------------------------------------------------------------------------|
| `CONTROL_PLANE_HOST`       | IP privada del control plane (`terraform output k8s_control_plane`). |
| `CONTROL_PLANE_USER`       | Usuario para acceso SSH al nodo master (valor: `ubuntu`).                   |
| `DOCKER_USERNAME`          | Usuario de Docker Hub.                                                      |
| `DOCKER_PASSWORD`          | Contraseña de Docker Hub.                                                   |
| `INFRA_BRIDGE_HOST`        | IP pública del nodo puente (`terraform output infra_bridge_node`).|
| `INFRA_BRIDGE_USER`        | Usuario para acceso SSH al nodo puente (valor: `ubuntu`).                   |
| `INFRA_BRIDGE_KEY`         | Contenido de la clave SSH ubicada en `/infra/ssh-key/devsu_ec2_key.pem`. Nota: Asegúrate de que al copiar el contenido al archivo de GitHub Actions no haya espacios en blanco al principio o al final, ya que esto podría causar errores en la ejecución.  |

## ℹ️ Información Importante

Todas las instancias **EC2** que forman parte del clúster de **Kubernetes** se encuentran dentro de una **subnet privada**. Debido a esta configuración de red, el acceso directo a dichas instancias no es posible desde el exterior.

#### 🔗 Nodo de Puente: `infra_bridge_node`

La única forma de acceder a estas instancias privadas es a través de una EC2 especialmente configurada llamada **`infra_bridge_node`**, la cual actúa como **puente (bridge)** hacia la subnet privada. Esta instancia se encarga de facilitar la comunicación entre el exterior y los recursos internos.

#### ⚙️ GitHub Actions y Despliegue

El workflow de **GitHub Actions** se comunica con el nodo `infra_bridge_node` para:

- Acceder al **control plane** del clúster de Kubernetes.
- Realizar los **despliegues** y actualizaciones en el entorno de Kubernetes.

#### 🌐 Acceso al Backend

La comunicación externa con el backend desplegado en Kubernetes se realiza mediante un **Elastic Load Balancer (ELB)** de **AWS**, que expone los servicios de backend de forma controlada y segura.

# Ejecución de Pipelines

En este repositorio se ejecutaron dos pipelines principales durante la prueba técnica:

### 🔴 [Pipeline con fallo en los tests](https://github.com/soyjosue/prueba-devops/actions/runs/15383843401)
Este pipeline presenta fallos en la ejecución de los tests, lo cual fue intencional para demostrar el control de errores en el flujo CI/CD.

### ✅ [Pipeline exitoso](https://github.com/soyjosue/prueba-devops/actions/runs/15383904035)
Este pipeline completó satisfactoriamente todas las etapas: instalación de dependencias, ejecución de tests y despliegue.

---

## Ambiente AWS de Pruebas

Como se explicó previamente, el entorno utilizado corresponde a un **ambiente de pruebas en AWS**.  
En caso de que aún esté activo al momento de la verificación, puedes consultar el API desplegado accediendo a la siguiente URL:

🔗 [http://devsu-alb-1585038574.us-east-1.elb.amazonaws.com/api/users](http://devsu-alb-1585038574.us-east-1.elb.amazonaws.com/api/users)
