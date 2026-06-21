package com.agilesolutions.common.dto;

import java.util.UUID;

public record VergunningResponse(UUID vergunningId, String zaaknummer, String status) {
}
