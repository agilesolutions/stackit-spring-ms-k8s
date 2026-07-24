# pod interconnection policies
```
| Source             | Destination        | Allowed          |
| ------------------ | ------------------ | ---------------- |
| Internet           | Traefik            | ✅               |
| Traefik            | Frontend           | ✅               |
| Frontend           | vergunning-service | ✅               |
| Frontend           | customer-service   | ✅               |
| Frontend           | PostgreSQL         | ❌               |
| vergunning-service | PostgreSQL         | ✅               |
| customer-service   | PostgreSQL         | ✅               |
| vergunning-service | customer-service   | Only if required |
| PostgreSQL         | Frontend           | ❌               |
| PostgreSQL         | Internet           | ❌               |

```